//
//  VictoryView.swift
//  MageGameApp
//
//  Created by aluno-02 on 28/08/25.
//

import SwiftUI

struct EndView: View {
    @Binding var health: Int
    var victory : Bool
    @State private var playerPhase: WizardPhase = .idle

    var onRestart: () -> Void
    var onGoToMenu: () -> Void
    private var result: String {
        if victory {
            return "You won"
        } else {
            return "You lose"
        }
    }
    private var matchText: String {
        if victory {
            return "Play Again"
        } else {
            return "Try again"
        }
    }
    var body: some View {
        
        
        VStack(spacing: 4){
            
            Spacer()
            VStack(spacing: 8){
                Wizard(isMini: true, health: $health, phase: $playerPhase)

                    .offset(y: 36)
                
                StrokedText(
                    
                    text: result,
                    size: 40,
                    color: .appPastel,
                    strokeColor: .black,
                    strokeWidth: 1
                )
            }
            .frame(width: 180, height: 170)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.appSand))
            Spacer()
            
            VStack{
                
                Button(action: onRestart) {
                    ZStack {
                        Image("Botao")
                        Text(matchText)
                            .foregroundColor(.appTree)
                            .font(.custom("PixelifySans-Bold", size: 21))
                    }
                }
                Button(action: onGoToMenu) {
                    ZStack {
                        Image("Botao")
                        Text("Return")
                            .foregroundColor(.appTree)
                            .font(.custom("PixelifySans-Bold", size: 24))
                    }
                }
            }
            .frame(width: 200, height: 170)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.appTree))
            Spacer()
        }.frame(width: 300, height: 400)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.appPastel)
            )
        
        
    }
}

#Preview {
    ZStack {
        
        
        EndView(
            health: .constant(3),
            victory: true,
            onRestart: { print("Restarting game...") },
            onGoToMenu: { print("Going to menu...") }
        )
    }
}
