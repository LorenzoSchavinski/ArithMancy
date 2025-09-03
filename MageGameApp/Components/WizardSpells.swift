//
//  WizardSpells.swift
//  MageGameApp
//
//  Created by aluno-02 on 27/08/25.
//

import SwiftUI
import UIKit

struct WizardSpells: View {
    var spellName: String
    var isEnemy: Bool
    
    var body: some View {
        // The body now simply calls the helper function to get the correct view.
        spellAnimationView()
                   .offset(x: 110)
        
        
    }
    
    // This is a helper function that builds and returns the correct view.
    @ViewBuilder
    private func spellAnimationView() -> some View {
        //let primaryColor = isEnemy ? "Red" : "Blue"
      //  let primaryName = "\(spellName)\(primaryColor)SpellAnimation"
            //primaryName = "iceBlueSpellAnimation"
        
      //  VStack(spacing: 32){
            
            if spellName.contains("snowflake"){
                WizardFactory.makeOneShotSpriteSheet(
                    imageName: "snowflakeBlueSpellAnimation",
                    columns: 16,
                    rows: 1,
                    frameCount: 16,
                    fps: 6,
                    nodeScale: 1.4 
                )
            }
            else if spellName.contains("lightning"){
                
                WizardFactory.makeOneShotSpriteSheet(
                    imageName: "lightningBlueSpellAnimation",
                    columns: 17,
                    rows: 1,
                    frameCount: 17,
                    fps: 10,
                    nodeScale: 2.5
                )
            }
            
            else if spellName.contains("sun"){
                
                WizardFactory.makeOneShotSpriteSheet(
                    imageName: "sunBlueSpellAnimation",
                    columns: 19,
                    rows: 1,
                    frameCount: 19,
                    fps: 11,
                    nodeScale: 1.2
                )
            }
        }
    //}
    
}
    
    #Preview {
        WizardSpells(spellName: "snowflake", isEnemy: false)
    }
