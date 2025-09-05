import SpriteKit

class WizardScene: SKScene {
    
    let showDebugGrid = true
    private var wizardNode: SKSpriteNode!
    private let frameWidth: CGFloat = 18
    private let frameHeight: CGFloat = 21
    private let idleFramesCount = 4
    private let scale = 4.0
    private let sheetName: String
    
    init(size: CGSize, sheetName: String) {
        self.sheetName = sheetName
        super.init(size: size)
    }
    
    // Obrigatório porque SKScene implementa NSCoding
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.size = view.bounds.size
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear

        guard let uiImage = UIImage(named: sheetName) else { return }
        let sheetPxW = uiImage.size.width  * uiImage.scale
        let sheetPxH = uiImage.size.height * uiImage.scale

        let wizardSpriteSheet = SKTexture(imageNamed: sheetName)
        wizardSpriteSheet.filteringMode = .nearest
        wizardSpriteSheet.usesMipmaps = false

        let fw = frameWidth
        let fh = frameHeight

        var idleFrames: [SKTexture] = []
        let targetRowFromTop = 0

        let insetX: CGFloat = 0.5
        let insetY: CGFloat = 0.5

        for column in 0..<idleFramesCount {
            let x_px = fw * CGFloat(column) + insetX
            let y_px_top = fh * CGFloat(targetRowFromTop) + insetY

            let x_norm = x_px / sheetPxW
            let y_norm = (sheetPxH - (y_px_top + fh - insetY*2)) / sheetPxH
            let w_norm = (fw - insetX*2) / sheetPxW
            let h_norm = (fh - insetY*2) / sheetPxH

            let rect = CGRect(x: x_norm, y: y_norm, width: w_norm, height: h_norm)
            idleFrames.append(SKTexture(rect: rect, in: wizardSpriteSheet))
        }

        let wizardNode = SKSpriteNode(texture: idleFrames.first)
        wizardNode.setScale(scale)
        wizardNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)

        let animateAction = SKAction.animate(with: idleFrames, timePerFrame: 0.2)
        wizardNode.run(.repeatForever(animateAction))

        self.addChild(wizardNode)

        if showDebugGrid {
            drawDebugGrid(on: wizardNode, frameSize: CGSize(width: frameWidth, height: frameHeight))
        }
    }

    
    func getDimensionsScaled() -> (width: CGFloat, height: CGFloat) {
        let w = frameWidth * scale
        let h = frameHeight * scale
        return (w, h)
    }
    
    func drawDebugGrid(on node: SKSpriteNode, frameSize: CGSize) {
        let scaledWidth = frameSize.width * node.xScale
        let scaledHeight = frameSize.height * node.yScale
        
        let shapeNode = SKShapeNode()
        let path = CGMutablePath()
        let rect = CGRect(x: -scaledWidth / 2, y: -scaledHeight / 2,
                          width: scaledWidth, height: scaledHeight)
        path.addRect(rect)
        
        shapeNode.path = path
        shapeNode.strokeColor = .red
        shapeNode.lineWidth = 1
        node.addChild(shapeNode)
    }
}
