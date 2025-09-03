//
//  GameButton.swift
//  MageGameApp
//
//  Created by aluno-02 on 01/09/25.
//

import SwiftUI

struct GameButton: View {
    var chosenSize: CGFloat
    var title: String
    var width: CGFloat = 180
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                Image("Botao")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
                Text(title)
                    .foregroundColor(.appTree)
                    .font(.custom("PixelifySans-SemiBold", size: chosenSize))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PressedScaleStyle())
    }
}

struct PressedScaleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}
