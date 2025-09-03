//
//  StatsScreen.swift
//  MageGameApp
//
//  Created by aluno-02 on 28/08/25.
//

import SwiftUI

struct StatsScreen: View {
    // Partidas/vitórias continuam simples com AppStorage
    @AppStorage("stats.numberOfGames") private var numberOfGames = 0
    @AppStorage("stats.numberOfVictories") private var numberOfVictories = 0

    // Estados apenas para exibir
    @State private var favoriteSpell: String = "-"
    @State private var favoriteSpellUses: Int = 0

    private let spellCountsKey = "stats.spellUseCounts.v1"

    var body: some View {
        ZStack {
            Image("FullStartbg")
                .resizable().scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.45))

            VStack(spacing: 8){
                StrokedText(text: "Your Stats", size: 48, color: .appPastel, strokeColor: .black, strokeWidth: 2)

             //   Image("Blue mage").scaleEffect(x: -1, y: 1)
                
                WizardFactory.makeSpriteSheet(
                    imageName: "idleBlueSprite",
                    columns: 4,
                    rows: 1,
                    rowIndex: 0,
                    frameCount: 4,
                    fps: 4.0,
                    nodeScale: 4.0
                )

                StrokedText(
                    text: "You have played \(numberOfGames) games",
                    size: 24, color: .appPastel, strokeColor: .black, strokeWidth: 2
                )
                
                StrokedText(
                    text: "You have won \(numberOfVictories) games",
                    size: 24, color: .appPastel, strokeColor: .black, strokeWidth: 2
                )
                StrokedText(
                    text: winrateText,
                    size: 24, color: .appPastel, strokeColor: .black, strokeWidth: 2
                )
                StrokedText(
                    text: "Your favorite spell is \(favoriteSpell)",
                    size: 24, color: .appPastel, strokeColor: .black, strokeWidth: 2
                )
                StrokedText(
                    text: "It has been used \(favoriteSpellUses) times",
                    size: 24, color: .appPastel, strokeColor: .black, strokeWidth: 2
                )
                

                Spacer()
            }
            .padding(.top, 40)
        }
        .onAppear(perform: deriveFavorite)
        // Opcional: se quiser atualizar “ao vivo” quando UserDefaults mudar:
        .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)) { _ in
            deriveFavorite()
        }
        .customBackButton() // <-- ADICIONE APENAS ESTA LINHA

    }

    private func deriveFavorite() {
        let counts = loadSpellCounts()
        if let (name, uses) = counts.max(by: { $0.value < $1.value }), uses > 0 {
            favoriteSpell = name
            favoriteSpellUses = uses
        } else {
            favoriteSpell = "-"
            favoriteSpellUses = 0
        }
    }

    private func loadSpellCounts() -> [String:Int] {
        if let data = UserDefaults.standard.data(forKey: spellCountsKey),
           let dict = try? JSONDecoder().decode([String:Int].self, from: data) {
            return dict
        }
        return [:]
    }
    
    private var winrateText: String {
            guard numberOfGames > 0 else {
                return "Winrate: N/A"
            }
            
            let winrateValue = Double(numberOfVictories) / Double(numberOfGames)
            
            let percentage = winrateValue * 100

            return String(format: "Winrate: %.1f%%", percentage)
        }
}


#Preview {
    StatsScreen()
}
