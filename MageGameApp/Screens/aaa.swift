//
//  aaa.swift
//  MageGameApp
//
//  Created by aluno-02 on 25/08/25.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct aaa: View {
    @State private var playerPhase: WizardPhase = .spell
    @State private var myHealth = 3
    
    var body: some View {
        VStack(){
            
            HStack{
                Spacer()
                //                WizardFactory.makeSpriteSheet(
                //                    imageName: "idleBlueSprite",
                //                    columns: 4,
                //                    rows: 1,
                //                    rowIndex: 0,
                //                    frameCount: 4,
                //                    fps: 5.0,
                //                    nodeScale: 4.0
                //                )
                //                WizardFactory.makeSpriteSheet(
                //                    imageName: "hurtBlueSprite",
                //                    columns: 3,
                //                    rows: 1,
                //                    rowIndex: 0,
                //                    frameCount: 3,
                //                    fps: 4.0,
                //                    nodeScale: 4.0
                //                )
                //                WizardFactory.makeSpriteSheet(
                //                    imageName: "passBlueSprite",
                //                    columns: 4,
                //                    rows: 1,
                //                    rowIndex: 0,
                //                    frameCount: 4,
                //                    fps: 5.0,
                //                    nodeScale: 4.0
//                //                )
//                WizardFactory.makeSpriteSheet(
//                    imageName: "spellBlueSprite",
//                    columns: 6,
//                    rows: 1,
//                    rowIndex: 0,
//                    frameCount: 6,
//                    fps: 4.0,
//                    nodeScale: 4.0
//                )
                //                WizardFactory.makeOneShotSpriteSheet(
                //                    imageName: "sunBlueSpellAnimation",
                //                    columns: 11,
                //                    rows: 1,
                //                    frameCount: 8,
                //                    fps: 4.0,
                //                    nodeScale: 0.1,
                //                    flipX: !isPlayerTurn
                //
                //                )
                //                WizardFactory.makeSpriteSheet(
                //                    imageName: "sunBlueSpellAnimation2",
                //                    columns: 12,
                //                    rows: 1,
                //                    frameCount: 11,
                //                    fps: 9.0,
                //                    nodeScale: 0.2
                //                )
//                Wizard(health: $myHealth, phase: $playerPhase)
//                
                ZStack{
                
                    
                    WizardFactory.makeSpriteSheet(
                                      imageName: "spellBlueSprite",
                                      columns: 6,
                                      rows: 1,
                                      rowIndex: 0,
                                      frameCount: 6,
                                      fps: 4.0,
                                      nodeScale: 4.0
                                  )
//                    
//                    WizardFactory.makeOneShotSpriteSheet(
//                        imageName: "sunBlueSpellAnimation",      // ex.: "sunBlueSpellAnimation"
//                        columns: 19, rows: 1,
//                        frameCount: 19, fps: 11.0,
//                        nodeScale: 1.2
//                    )
//                    .offset(x: 100)
                    
                    
//                    WizardFactory.makeSpriteSheet(
//                        imageName: "hurtRedSprite",
//                        columns: 3,
//                        rows: 1,
//                        rowIndex: 0,
//                        frameCount: 3,
//                        fps: 4.0,
//                        nodeScale: 4.0
//                    )
                    WizardFactory.makeSpriteSheet(
                        imageName: "sunBlueSpellAnimation",
                        columns: 19,
                        rows: 1,
                        frameCount: 19,
                        fps: 9.0,
                        nodeScale: 1.2
                    )
                    
                   
                    
                    
                }
                //                WizardFactory.makeOneShotSpriteSheet(
                //                    imageName: "sunBlueSpellAnimation",
                //                    columns: 11,
                //                    rows: 1,
                //                    frameCount: 11,
                //                    fps: 12.0,
                //                    nodeScale: 0.2,
                //                    flipX: !isPlayerTurn
                //                )
                
                
                Spacer()
            }
            
            
            Spacer()
            
        }
        .padding(.vertical, 64)
        .padding(.horizontal, 40)
    }
    
    func showAnimation(imageName: String){
        
    }
}

#Preview {
    aaa()
}
