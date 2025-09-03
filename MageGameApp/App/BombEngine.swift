//
//  BombEngine.swift
//  MageGameApp
//
//  Created by aluno-02 on 27/08/25.
//

import Foundation
import Combine

/// Controla o timer/turnos da bomba e notifica a UI via closures.
/// O motor não mexe em UI — apenas informa eventos.
final class BombEngine: ObservableObject {
    // Config
    let initialTime: Double
    let timeReductionPerTurn: Double
    let minTime: Double
    let resetTimeAfterExplosion: Double

    // Estado público só-leitura (a UI pode observar)
    @Published private(set) var timeRemaining: Double
    @Published private(set) var currentMaxTime: Double
    @Published private(set) var isPlayerTurn: Bool

    // Eventos para a tela reagir
    var onTick: ((Double) -> Void)?
    /// Dispara quando a bomba explode. Para o timer e espera a UI decidir quando retomar.
    var onExplode: ((Bool /*wasPlayerTurn*/) -> Void)?
    /// Dispara quando a resposta está correta e o turno passa.
    var onPass: ((Double /*newMax*/, Bool /*newIsPlayer*/ ) -> Void)?

    private var timer: Timer?

    init(
        initialTime: Double = 7.0,
        timeReductionPerTurn: Double = 0.4,
        minTime: Double = 2.0,
        resetTimeAfterExplosion: Double = 4.0,
        startsWithPlayer: Bool = true
    ) {
        self.initialTime = initialTime
        self.timeReductionPerTurn = timeReductionPerTurn
        self.minTime = minTime
        self.resetTimeAfterExplosion = resetTimeAfterExplosion

        self.currentMaxTime = initialTime
        self.timeRemaining = initialTime
        self.isPlayerTurn = startsWithPlayer
    }

    // MARK: - Controle do ciclo
    func start() {
        restartTimer()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    /// Chame quando o jogador (ou IA) resolver o cálculo a tempo.
    func handleCorrectAnswer() {
        // Reduz janela para o próximo turno (com piso)
        let newMax = max(minTime, currentMaxTime - timeReductionPerTurn)
        currentMaxTime = newMax
        timeRemaining = newMax

        // Passa o turno
        isPlayerTurn.toggle()
        onPass?(currentMaxTime, isPlayerTurn)
        // Timer já está rodando — só reinicia a janela interna
        restartTimer()
    }

    /// A UI deve chamar depois de terminar as animações/efeitos da explosão.
    func resetAfterExplosionAndResume() {
        currentMaxTime = resetTimeAfterExplosion
        timeRemaining = currentMaxTime
        // Passa o turno pós-explosão
        isPlayerTurn.toggle()
        restartTimer()
    }

    /// Reseta o motor ao estado inicial e para o timer.
    func hardReset(startsWithPlayer: Bool = true) {
        stop()
        currentMaxTime = initialTime
        timeRemaining = initialTime
        isPlayerTurn = startsWithPlayer
    }

    // MARK: - Interno
    private func restartTimer() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard self.timeRemaining > 0.1 else {
                self.stop()
                self.onExplode?(self.isPlayerTurn)
                return
            }
            self.timeRemaining -= 0.1
            self.onTick?(self.timeRemaining)
        }
        if let timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}
