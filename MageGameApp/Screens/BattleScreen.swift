    //
    //  BattleScreen.swift
    //  MageGameApp
    //
    //  Created by aluno-02 on 22/08/25.
    //

    import SwiftUI

    struct BattleScreen: View {
        @EnvironmentObject var router: NavigationRouter
        //MARK: Relacionado com a bomba
        @StateObject private var bombEngine = BombEngine(
            initialTime: 7.0,
            timeReductionPerTurn: 0.4,
            minTime: 2.0,
            resetTimeAfterExplosion: 4.0,
            startsWithPlayer: true
        )
        @State private var bombActive = false
        
        @State private var backgroundOpacity = 0.0
        @State private var isPlayerTurn = true
        
//         BattleScreen.swift (coloque perto dos @State)
//        private let miniWizardSize = CGSize(width: 140, height: 140)
//     private let bombTickSize   = CGSize(width: 120, height: 120)

        
        @State private var playerPhase: WizardPhase = .idle
        @State private var enemyPhase: WizardPhase = .idle

        
        //views
        @State private var showMathScroll = false
        @State private var showCardDeck = false
        @State private var showDrawingScroll = false
        @State private var showEndView = false
        @State private var feedbackText: String? = nil

        @State private var currentSpell: String? = nil
        @State private var myHealth = 3
        @State private var enemyHealth = 3
        @State private var gameResultIsVictory = false
        @State private var sessionId = UUID()
        
        
        @AppStorage("stats.numberOfGames") private var numberOfGames = 0
        @AppStorage("stats.numberOfVictories") private var numberOfVictories = 0
        
        // Dicionário [spell: uses] salvo como JSON
        private let spellCountsKey = "stats.spellUseCounts.v1"
        
        
        // Timer interno do BombEngine já publica ticks via closure
        
        var body: some View {
            ZStack {
                Image("Battlebg")
                    .resizable()
                    .ignoresSafeArea()
                    .overlay(
                        Color.black.opacity(backgroundOpacity)
                    )
                
                HStack {
                    Wizard(health: $myHealth, phase: $playerPhase)
    //                    .overlay(
    //                        Color.black.opacity(backgroundOpacity)
    //                    )
                    Spacer()
                    Wizard(isEnemy: true, health: $enemyHealth, phase: $enemyPhase)
    //                    .overlay(
    //                        Color.black.opacity(backgroundOpacity)
    //                    )
                }
                .padding(.horizontal, 40)
                .offset(y: 75)
                
                Color.black
                        .opacity(backgroundOpacity)
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                
                if let text = feedbackText {
                    Text(text)
                        .font(.custom("PixelifySans-SemiBold", size: 24))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)   // ou Color.black.opacity(0.6)
                        .clipShape(Capsule())
                        .shadow(radius: 8)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .offset(y: 100)
                        .padding(.top, 20)
                        .zIndex(100)
                }

                
                if showMathScroll {
                   VStack(){
                        
                        HStack{
                            Wizard(isMini: true, health: $myHealth, phase: $playerPhase)
                            Spacer()
                            BombTick(turnArrow: $isPlayerTurn)
                                .offset(y:-40)
                                .fixedSize()
                            Spacer()
                            Wizard(isEnemy: true, isMini: true, health: $enemyHealth, phase: $enemyPhase)
                                
                            
                        }
    //                    HStack(alignment: .center, spacing: 24) {
    //                        Wizard(isMini: true, health: $myHealth, phase: $playerPhase)
    //                            .frame(width: miniWizardSize.width, height: miniWizardSize.height, alignment: .center)
    //                            .fixedSize()
    //
    //                        BombTick(turnArrow: $isPlayerTurn)
    //                            .frame(width: bombTickSize.width, height: bombTickSize.height, alignment: .center)
    //                            .offset(y: -40)
    //                            .fixedSize()
    //
    //                        Wizard(isEnemy: true, isMini: true, health: $enemyHealth, phase: $enemyPhase)
    //                            .frame(width: miniWizardSize.width, height: miniWizardSize.height, alignment: .center)
    //                            .fixedSize()
    //                    }
    //                    // evita animação implícita de layout quando muda a fase
    //                    .animation(nil, value: playerPhase)
    //                    .animation(nil, value: enemyPhase)

                        
                        MathChallengeView(isPlayersTurn : $isPlayerTurn, onAnswerSubmitted: handleAnswer)
                            .offset(y: 20)
                        // .transition(.scale.animation(.spring()))
                            .transition(.opacity)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                        
                    }
                    .padding(.vertical, 64)
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    
                }
                
                
                if let spellName = currentSpell{
                    WizardSpells(spellName: spellName, isEnemy: !isPlayerTurn)     //faz o spell
                }
                
                
                
                if showCardDeck{    //mostra o deck de cartas
                    CardDeck()
                }
                
                if showEndView{
                    EndView(health: $myHealth, victory: gameResultIsVictory,
                            onRestart: restartMatch,
                            onGoToMenu: goToMenu)
                    
                }
                
                if showDrawingScroll {
                    DrawingScrollOverlay(
                        isVisible: $showDrawingScroll,
                        title: "Desenhe um dos três elementos",
                        scrollImageName: "Drawing Scroll",
                        scrollInsetsPct: EdgeInsets(top: 0.14,
                                                    leading: 0.17,
                                                    bottom: 0.14,
                                                    trailing: 0.14),
                        maxScrollWidth: 360
                    ) { label, confidence in
                        // handle result
                        print(label)
                        showCardDeck = false
                        showDrawingScroll = false
                        
                        recordSpellUse(label)                //salva no banco
                        let casterIsEnemy = false
                        let castDelay: TimeInterval = 1.0          // quer 2s DEPOIS do spell do mago
                        let fxDuration: TimeInterval = 1.3 // ajuste se seu design for o inimigo lançar aqui
                        let totalDuration = castDelay + fxDuration // dura spell do mago + FX
                        let hurtTail: TimeInterval   = 0.8        // “últimos segundos” para o hurt
                        let current = sessionId

                        triggerSpell(casterIsEnemy: casterIsEnemy,
                                     totalDuration: totalDuration,
                                     hurtTail: hurtTail)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + castDelay) {
                            guard current == sessionId else { return }
                            currentSpell = label                //ativa a animacao

                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                            guard current == sessionId else { return }
                            backgroundOpacity = 0.6
                            currentSpell = nil
                            showMathScroll = true
                            // retoma bomba e turno após animação de feitiço
                            bombEngine.resetAfterExplosionAndResume()
                            isPlayerTurn = bombEngine.isPlayerTurn
                            bombActive = true
                            if !isPlayerTurn {
                                scheduleEnemyAutoMove()
                            }
                        }
                    }
                    .zIndex(10)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear(perform: startGameSequence)
            .customBackButton() 

            
            
        }
        
        func startGameSequence() {
            let current = sessionId
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard current == sessionId else { return }
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.backgroundOpacity = 0.6
                    self.showMathScroll = true
                    bombActive = true
                    wireBombEngine()
                    bombEngine.start()
                }
            }
        }

        private func wireBombEngine() {
            isPlayerTurn = bombEngine.isPlayerTurn
            bombEngine.onTick = { _ in
                // O valor é lido direto em BombTick via binding
            }
            bombEngine.onPass = { _, newIsPlayer in
                isPlayerTurn = newIsPlayer
                if !newIsPlayer {
                    scheduleEnemyAutoMove()
                }
            }
            bombEngine.onExplode = { wasPlayersTurn in
                handleExplosion(wasPlayersTurn: wasPlayersTurn)
            }
        }

        private func scheduleEnemyAutoMove() {
            // IA simples: chance de acerto; caso contrário, deixa explodir
            let willAnswerCorrectly = Int.random(in: 0...100) < 65
            let delay = min(2.0, max(0.6, bombEngine.currentMaxTime * 0.5))
            let current = sessionId
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                guard current == sessionId else { return }
                guard !isPlayerTurn, showMathScroll, !showDrawingScroll, !showEndView else { return }
                if willAnswerCorrectly {
                    triggerPass(forEnemy: true)
                    bombEngine.handleCorrectAnswer()
                }
            }
        }
        func handleAnswer(isCorrect: Bool) {
            if isCorrect {
                showFeedback("Resposta correta!")
                
                if isPlayerTurn {
                            triggerPass(forEnemy: false)
                        } else {
                            triggerPass(forEnemy: true)
                        }
                        bombEngine.handleCorrectAnswer()
            } else {
                showFeedback("Resposta incorreta!")
            }
        }
        
        private func triggerPass(forEnemy: Bool) {
            let duration: TimeInterval = 0.6  // ajuste fino
            let current = sessionId
            if forEnemy {
                enemyPhase = .pass
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    guard current == sessionId else { return }
                    enemyPhase = .idle
                }
            } else {
                playerPhase = .pass
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    guard current == sessionId else { return }
                    playerPhase = .idle
                }
            }
        }
        
        func handleExplosion(wasPlayersTurn: Bool) {
            bombActive = false
            bombEngine.stop()
            print("BOOM! A bomba explodiu.")
            showMathScroll = false

            // 1) aplica dano primeiro
            if wasPlayersTurn {
                myHealth = max(0, myHealth - 1)
                print("Jogador tomou dano. Vidas: \(myHealth)")
            } else {
                enemyHealth = max(0, enemyHealth - 1)
                print("Inimigo tomou dano. Vidas: \(enemyHealth)")
            }

            // 2) checa fim de jogo logo após aplicar dano
            if enemyHealth <= 0 {
                gameResultIsVictory = true
                Winner(gameResultIsVictory: true)
                return
            } else if myHealth <= 0 {
                gameResultIsVictory = false
                Winner(gameResultIsVictory: false)
                return
            }

            // 3) se explodiu no inimigo, só toca o feitiço visual e retorna
            if !wasPlayersTurn {
                MageSpell()   // apenas efeito visual; a vida já foi reduzida acima
                return
            }

            // 4) explodiu no jogador → retoma a matemática
            withAnimation { showMathScroll = true }
            bombEngine.resetAfterExplosionAndResume()
            isPlayerTurn = bombEngine.isPlayerTurn
            bombActive = true
            if !isPlayerTurn { scheduleEnemyAutoMove() }
        }

        private func checkGameOver() {
            if enemyHealth <= 0 {
                gameResultIsVictory = true
                Winner(gameResultIsVictory: true)
            } else if myHealth <= 0 {
                gameResultIsVictory = false
                Winner(gameResultIsVictory: false)
            }
        }
        
        
        //func passTheBomb() {}
        
        func resetAfterExplosion() {
            bombEngine.resetAfterExplosionAndResume()
            isPlayerTurn = bombEngine.isPlayerTurn
            bombActive = true
            print("Bomba reiniciada! Novo tempo máximo: \(String(format: "%.2f", bombEngine.currentMaxTime))s")
        }
        
        
        func MageSpell(){
            backgroundOpacity = 0.0
            showCardDeck = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                showDrawingScroll = true
                bombActive = false // Pausa durante o desenho
                bombEngine.stop()
                
            }
            
        }
        
        func Winner(gameResultIsVictory : Bool) {
            numberOfGames += 1
            showMathScroll = false
            showCardDeck = false
            showDrawingScroll = false
            currentSpell = nil
            showEndView = true
            if gameResultIsVictory{
                numberOfVictories+=1
            }else{
            }
            return
        }
        
        private func triggerSpell(casterIsEnemy: Bool,
                                  totalDuration: TimeInterval,
                                  hurtTail: TimeInterval) {

            // 1) caster entra em SPELL
            if casterIsEnemy {
                enemyPhase = .spell
            } else {
                playerPhase = .spell
            }

            // 2) agenda HURT no alvo nos últimos segundos da animação
            let targetIsEnemy = !casterIsEnemy
            let current = sessionId

            DispatchQueue.main.asyncAfter(deadline: .now() + max(0, totalDuration - hurtTail)) {
                guard current == sessionId else { return }
                if targetIsEnemy {
                    enemyPhase = .hurt
                } else {
                    playerPhase = .hurt
                }
            }

            // 3) ao final total, volta ambos a IDLE (encerra spell e hurt)
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                guard current == sessionId else { return }
                if casterIsEnemy {
                    enemyPhase = .idle
                } else {
                    playerPhase = .idle
                }
                if targetIsEnemy {
                    // garante que sai do hurt
                    enemyPhase = .idle
                } else {
                    playerPhase = .idle
                }
            }
        }

        private func showFeedback(_ text: String, duration: TimeInterval = 1.0) {
            feedbackText = text
            let current = sessionId
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                guard current == sessionId else { return }
                withAnimation(.easeOut(duration: 0.25)) {
                    feedbackText = nil
                }
            }
        }


        private func restartMatch() {
            // Reinicia estados principais
            myHealth = 3
            enemyHealth = 3
            gameResultIsVictory = false
            showEndView = false
            backgroundOpacity = 0.0
            showCardDeck = false
            showDrawingScroll = false
            currentSpell = nil
            isPlayerTurn = true
            bombActive = false
            // Reseta engine
            bombEngine.hardReset(startsWithPlayer: true)
            // Nova sessão: invalida callbacks antigos
            sessionId = UUID()
            // Recomeça a sequência do jogo
            startGameSequence()
        }

        private func goToMenu() {
            showEndView = false
            router.path.removeLast(router.path.count)
        }
        
        private func recordSpellUse(_ name: String) {
            guard !name.isEmpty else { return }
            var counts = loadSpellCounts()
            counts[name, default: 0] += 1
            saveSpellCounts(counts)
        }
        
        private func loadSpellCounts() -> [String: Int] {
            if let data = UserDefaults.standard.data(forKey: spellCountsKey),
               let dict = try? JSONDecoder().decode([String: Int].self, from: data) {
                return dict
            }
            return [:]
        }
        
        private func saveSpellCounts(_ dict: [String: Int]) {
            if let data = try? JSONEncoder().encode(dict) {
                UserDefaults.standard.set(data, forKey: spellCountsKey)
            }
        }
    }





    #Preview {
        BattleScreen()
    }
