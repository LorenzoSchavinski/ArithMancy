//
//  OneShotSprite.swift
//  MageGameApp
//
//  Created by aluno-02 on 02/09/25.
//

import SpriteKit
import UIKit
import SwiftUICore
import _SpriteKit_SwiftUI

extension WizardFactory {

    private struct OneShotSprite: View {
        let imageName: String
        let columns: Int
        let rows: Int
        let rowIndex: Int
        let frameCount: Int
        let fps: Double
        let nodeScale: CGFloat
        let showDebugGrid: Bool
        let options: SpriteView.Options
        let onFinish: (() -> Void)?

        @State private var visible = true

        var body: some View {
            Group {
                if visible {
                    WizardFactory.makeSpriteSheet(
                        imageName: imageName,
                        columns: columns,
                        rows: rows,
                        rowIndex: rowIndex,
                        frameCount: frameCount,
                        fps: fps,
                        nodeScale: nodeScale,
                        showDebugGrid: showDebugGrid,
                        options: options
                    )
                }
            }
            .onAppear {
                // duração exata de 1 ciclo
                let duration = max(0.01, Double(frameCount) / max(fps, 0.01))
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    visible = false
                    onFinish?()
                }
            }
        }
    }

    static func makeOneShotSpriteSheet(
        imageName: String,
        columns: Int,
        rows: Int,
        rowIndex: Int = 0,
        frameCount: Int,
        fps: Double = 10.0,
        nodeScale: CGFloat = 3.0,
        showDebugGrid: Bool = false,
        options: SpriteView.Options = [.allowsTransparency],
        onFinish: (() -> Void)? = nil
    ) -> some View {
        OneShotSprite(
            imageName: imageName,
            columns: columns,
            rows: rows,
            rowIndex: rowIndex,
            frameCount: frameCount,
            fps: fps,
            nodeScale: nodeScale,
            showDebugGrid: showDebugGrid,
            options: options,
            onFinish: onFinish
        )
    }
}
