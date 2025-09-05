//
//  WizardFactory.swift
//  MageGameApp
//
//  Created by aluno-02 on 26/08/25.
//

import Foundation
import SwiftUI
import SpriteKit
import _SpriteKit_SwiftUI
import UIKit

struct WizardFactory {
    static func makeWizard(sheetName: String,
                           scale: CGFloat = 4.0,
                           options: SpriteView.Options = [.allowsTransparency]) -> some View {
                let view = makeSpriteSheet(
            imageName: sheetName,
            columns: 4,
            rows: 1,
            rowIndex: 0,
            frameCount: 4,
            fps: 6.0,
            nodeScale: scale,
            showDebugGrid: false,
            options: options
        )
        return AnyView(view)
    }

    static func makeSpriteSheet(imageName: String,
                                columns: Int,
                                rows: Int,
                                rowIndex: Int = 0,
                                frameCount: Int,
                                fps: Double = 5.0,
                                nodeScale: CGFloat = 4.0,
                                showDebugGrid: Bool = false,
                                options: SpriteView.Options = [.allowsTransparency]) -> some View {
        let cfg = SpriteSheetScene.Config(
            imageName: imageName,
            columns: columns,
            rows: rows,
            rowIndex: rowIndex,
            frameCount: frameCount,
            fps: fps,
            nodeScale: nodeScale,
            showDebugGrid: showDebugGrid
            //flipY: true
        )
        let scene = SpriteSheetScene(size: .init(width: 1, height: 1), config: cfg)
        // Calcula o tamanho do frame em pontos com base na imagem real
        let frameWpts: CGFloat
        let frameHpts: CGFloat
        if let uiImage = UIImage(named: imageName) {
            frameWpts = uiImage.size.width / CGFloat(columns)
            frameHpts = uiImage.size.height / CGFloat(rows)
        } else {
            frameWpts = 32
            frameHpts = 32
        }
        let view = SpriteView(scene: scene, options: options)
            .frame(width: frameWpts * nodeScale, height: frameHpts * nodeScale)
        return AnyView(view)
    }
}

