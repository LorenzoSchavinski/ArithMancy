//
//  SpellsScreen.swift
//  MageGameApp
//
//  Created by aluno-02 on 01/09/25.
//

import SwiftUI

struct SpellsScreen: View {
    var body: some View {
        ZStack{ Image("FullStartbg")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .overlay(Color.black.opacity(0.45))

        VStack{
            StrokedText(
                       text: "Spells Gallery",
                       size: 38,
                       color: .appPastel,
                       strokeColor: .black,
                       strokeWidth: 1
                   )
            Spacer()
        }
            VStack(spacing: 40){
                WizardFactory.makeSpriteSheet(
                    imageName: "sunBlueSpellAnimation",
                    columns: 19,
                    rows: 1,
                    frameCount: 19,
                    fps: 11.0,
                    nodeScale: 1.2
                )
                WizardFactory.makeSpriteSheet(
                        imageName: "lightningBlueSpellAnimation",
                        columns: 17,
                        rows: 1,
                        frameCount: 17,
                        fps: 11,
                        nodeScale: 1.6
                    )
                WizardFactory.makeSpriteSheet(
                        imageName: "snowflakeBlueSpellAnimation",
                        columns: 16,
                        rows: 1,
                        frameCount: 16,
                        fps: 8,
                        nodeScale: 1.2
                    )
            
        }
       }
    }
}


#Preview {
    SpellsScreen()
}
