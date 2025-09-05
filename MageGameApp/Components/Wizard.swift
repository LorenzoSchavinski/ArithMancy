//
//  Wizard.swift
//  MageGameApp
//
//  Created by aluno-02 on 22/08/25.
//

import SwiftUI
import _SpriteKit_SwiftUI

enum WizardPhase: Equatable {
    case idle
    case pass
    case spell
    case hurt
}

struct Wizard: View {
    var isEnemy = false
    var isMini = false
    @Binding var health: Int
    @Binding var phase: WizardPhase

    private var heartImageName: String {
        let validHealth = max(0, min(health, 3))
        return "\(validHealth) Heart"
    }

    var body: some View {
        ZStack {
            Image(heartImageName)

            let config = animationConfig(for: phase, isEnemy: isEnemy)
            WizardFactory.makeSpriteSheet(
                imageName: config.imageName,
                columns: config.columns,
                rows: 1,
                rowIndex: 0,
                frameCount: config.frameCount,
                fps: Double(config.fps),
                nodeScale: isMini ? 3.0 : 4.0
            )
            .offset(y: isMini ? -50 : -70)
            .offset(x: isEnemy ? -9 : 9)
        }
    }

    private func animationConfig(for phase: WizardPhase, isEnemy: Bool)
    -> (imageName: String, columns: Int, frameCount: Int, fps: Int) {
        let user = isEnemy ? "Red" : "Blue"

        switch phase {
        case .idle:
            return (isEnemy ? "idleRedSprite" : "idleBlueSprite", 4, 4, 6)

        case .pass:
            let imageName = "pass\(user)Sprite"
            return (imageName, 4, 4, 5)

        case .spell:
            let imageName = "spell\(user)Sprite"
            return (imageName, 6, 6, 4)

        case .hurt:
            let imageName = "hurt\(user)Sprite"
            return (imageName, 3, 3, 4)
        }
    }
}

#Preview {
    
  //  Wizard(health: .constant(3))
}
