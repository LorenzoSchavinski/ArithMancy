import SwiftUI
import Vision
import CoreML

struct DrawingScrollOverlay: View {
    @Binding var isVisible: Bool
    var title: String = "Desenhe um dos três elementos"
    var scrollImageName: String = "Drawing Scroll" // <- put your parchment asset name here
    var scrollInsetsPct = EdgeInsets(top: 0.19, leading: 0.18, bottom: 0.14, trailing: 0.18)
    var maxScrollWidth: CGFloat = 360
    var onClassified: (_ label: String, _ confidencePct: Int) -> Void

    // Canvas state (reuses your Line/DrawingView)
    @State private var lines: [Line] = []
    @State private var currentLine = Line()
    @State private var message: String = ""
    @State private var isBusy = false

    init(isVisible: Binding<Bool>,
         title: String = "Desenhe um dos três elementos",
         scrollImageName: String = "Drawing Scroll",
         scrollInsetsPct: EdgeInsets = EdgeInsets(top: 0.19, leading: 0.18, bottom: 0.14, trailing: 0.18),
         maxScrollWidth: CGFloat = 360,
         onClassified: @escaping (_ label: String, _ confidencePct: Int) -> Void) {
        _isVisible = isVisible
        self.title = title
        self.scrollImageName = scrollImageName
        self.scrollInsetsPct = scrollInsetsPct
        self.maxScrollWidth = maxScrollWidth
        self.onClassified = onClassified
        _message = State(initialValue: title)
    }

    var body: some View {
        if isVisible {
            ZStack {
                Color.black.opacity(0.6).ignoresSafeArea()

                GeometryReader { geo in
                    // 1) Size the scroll preserving its aspect ratio
                    let uiImg = UIImage(named: scrollImageName)
                    let aspect = (uiImg?.size.width ?? 3) / max((uiImg?.size.height ?? 5), 1)
                    let scrollW = min(geo.size.width - 32, maxScrollWidth)
                    let scrollH = scrollW / max(aspect, 0.0001)

                    // 2) Compute inner drawing rect as a % of the scroll image
                    let innerX = scrollW * scrollInsetsPct.leading
                    let innerY = scrollH * scrollInsetsPct.top
                    let innerW = scrollW * (1 - scrollInsetsPct.leading - scrollInsetsPct.trailing)
                    let innerH = scrollH * (1 - scrollInsetsPct.top - scrollInsetsPct.bottom)

                    VStack(spacing: 12) {
                        Text(message)
                            .font(.custom("PixelifySans-Bold", size: 22))
                            .foregroundColor(.white)
                            .shadow(radius: 2)

                        ZStack {
                            Image(scrollImageName)
                                .resizable()
                                .frame(width: scrollW, height: scrollH)
                                .allowsHitTesting(false)

                            // The actual canvas on top of scroll “paper”
                            DrawingView(lines: $lines, currentLine: $currentLine)
                                .frame(width: innerW, height: innerH)
                                .background(Color.white)
                                .cornerRadius(6)
                                // position inside the scroll
                                .offset(x: (innerX - scrollW/2) + innerW/2,
                                        y: (innerY - scrollH/2) + innerH/2)
                        }
                        .frame(width: scrollW, height: scrollH)
                        .clipped()

                        HStack(spacing: 12) {
                          //  Button("Clear") {
                            Button{
                                lines.removeAll(); currentLine = Line()
                                message = title
                            }label:{
                                ZStack{
                                    Image("Botao")
                                    Text("Limpar")
                                        .foregroundColor(.appTree)
                                        .font(.custom("PixelifySans-Bold", size: 21))
                                }
                            }
                           // .buttonStyle(.borderedProminent)

                           // Button(isBusy ? "Analisando..." : "Analisar") {
                            Button{
                                guard !isBusy else { return }
                                isBusy = true
                                analyzeNow(canvasSize: CGSize(width: innerW, height: innerH))
                            }label:{
                                ZStack{
                                    Image("Botao")
                                    Text(isBusy ? "Analyzing..." : "Analyze")
                                        .foregroundColor(.appTree)
                                        .font(.custom("PixelifySans-Bold", size: 21))
                                }
                            }
                         //   .buttonStyle(.borderedProminent)
                            .disabled(isBusy)

                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(20)
            }
            .transition(.opacity)
            .animation(.easeInOut, value: isVisible)
        }
    }

    // Render ONLY the canvas (not the scroll)
    private func analyzeNow(canvasSize: CGSize) {
        let viewToRender = DrawingView(lines: $lines, currentLine: $currentLine)
            .frame(width: canvasSize.width, height: canvasSize.height)
            .background(Color.white)

        let renderer = ImageRenderer(content: viewToRender)
        renderer.scale = 3.0

        guard let uiImage = renderer.uiImage,
              let pixelBuffer = uiImage.pixelBuffer(width: 299, height: 299) else {
            message = "Falha ao capturar o desenho."
            isBusy = false
            return
        }
        classify(pixelBuffer)
    }

    private func classify(_ pixelBuffer: CVPixelBuffer) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let cfg = MLModelConfiguration()
                let model = try QuickDrawImageClassifier(configuration: cfg)
                let vnModel = try VNCoreMLModel(for: model.model)

                let req = VNCoreMLRequest(model: vnModel) { request, _ in
                    let results = (request.results as? [VNClassificationObservation]) ?? []
                    let top = results.first
                    DispatchQueue.main.async {
                        if let top {
                            let pct = Int(top.confidence * 100)
                            self.message = "Feitiço de \(top.identifier)? (\(pct)%)"
                            self.onClassified(top.identifier, pct)
                        } else {
                            self.message = "Sem resultado."
                        }
                        self.isBusy = false
                    }
                }

                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
                try handler.perform([req])
            } catch {
                DispatchQueue.main.async {
                    self.message = "Erro ao classificar."
                    self.isBusy = false
                }
            }
        }
    }
}
