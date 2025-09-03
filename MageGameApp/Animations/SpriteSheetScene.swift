import SpriteKit
import UIKit

final class SpriteSheetScene: SKScene {
    struct Config {
        let imageName: String
        let columns: Int
        let rows: Int
        let rowIndex: Int
        let frameCount: Int
        let fps: Double
        let nodeScale: CGFloat
        let showDebugGrid: Bool
    }

    private let config: Config
    private var spriteNode: SKSpriteNode!

    init(size: CGSize, config: Config) {
        self.config = config
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        self.size = view.bounds.size
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear

        guard let uiImage = UIImage(named: config.imageName), let cg = uiImage.cgImage else {
            return
        }

        let sheetPxW = cg.width
        let sheetPxH = cg.height

        let framePxW = max(1, sheetPxW / config.columns)
        let framePxH = max(1, sheetPxH / config.rows)

        var frames: [SKTexture] = []
        let framesToBuild = max(1, config.frameCount)
        for i in 0..<framesToBuild {
            let col = i % config.columns
            let row = config.rowIndex // 0 = topo
            let x = col * framePxW
            let yTop = row * framePxH
            // CGImage cropping rect origin é top-left, então y = yTop diretamente
            let cropRect = CGRect(x: x, y: yTop, width: framePxW, height: framePxH)
            if let sub = cg.cropping(to: cropRect) {
                let tex = SKTexture(cgImage: sub)
                tex.filteringMode = .nearest
                frames.append(tex)
            }
        }

        guard let first = frames.first else { return }
        spriteNode = SKSpriteNode(texture: first)
        spriteNode.setScale(config.nodeScale)
        spriteNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(spriteNode)

        let timePerFrame = max(0.01, 1.0 / config.fps)
        let animate = SKAction.animate(with: frames, timePerFrame: timePerFrame)
        spriteNode.run(.repeatForever(animate))

        if config.showDebugGrid {
            drawDebugGrid(on: spriteNode, columns: config.columns, rows: config.rows)
        }
    }

    private func drawDebugGrid(on node: SKSpriteNode, columns: Int, rows: Int) {
        let w = node.size.width
        let h = node.size.height
        let shape = SKShapeNode()
        let path = CGMutablePath()

        // outer rect
        path.addRect(CGRect(x: -w/2, y: -h/2, width: w, height: h))
        // grid lines
        let cellW = w / CGFloat(columns)
        let cellH = h / CGFloat(rows)
        for c in 1..<columns {
            let x = -w/2 + CGFloat(c) * cellW
            path.move(to: CGPoint(x: x, y: -h/2))
            path.addLine(to: CGPoint(x: x, y: h/2))
        }
        for r in 1..<rows {
            let y = -h/2 + CGFloat(r) * cellH
            path.move(to: CGPoint(x: -w/2, y: y))
            path.addLine(to: CGPoint(x: w/2, y: y))
        }

        shape.path = path
        shape.strokeColor = .red
        shape.lineWidth = 1
        node.addChild(shape)
    }
}


