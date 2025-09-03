//
//  ContentView.swift
//  MageGameApp
//
//  Created by aluno-02 on 21/08/25.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    @State private var lines: [Line] = []
        @State private var currentLine = Line()

        // As outras variáveis de estado
        @State private var capturedImage: UIImage?
        @State private var predictionText: String = "Desenhe um dos tres elementos"
        
        var body: some View {
            VStack(spacing: 20) {
                StrokedText(
                    text: predictionText,
                           size: 24,
                           color: .appPastel,
                           strokeColor: .black,
                           strokeWidth: 2
                       )
                    
                DrawingView(lines: $lines, currentLine: $currentLine)
                
                Button("Analisar Desenho") {
                    // ✅ A MÁGICA FINAL:
                    // Criamos uma NOVA instância de DrawingView SÓ PARA O RENDERER.
                    // Passamos os dados atuais para ela. O renderer agora vai
                    // fotografar o quadro certo!
                    let viewToRender = DrawingView(lines: $lines, currentLine: $currentLine)
                    let renderer = ImageRenderer(content: viewToRender)
                    
                    renderer.scale = 3.0
                    
                    if let uiImage = renderer.uiImage {
                        self.capturedImage = uiImage
                        
                        guard let pixelBuffer = uiImage.pixelBuffer(width: 299, height: 299) else {
                            return
                        }
                        
                        self.predictionText = "Analisando..."
                        classify(image: pixelBuffer)
                    }
                }
                .font(.custom("PixelifySans-Bold", size: 8))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                
                Button("Limpar Desenho"){
                    lines.removeAll()
                }
                .font(.custom("PixelifySans-Bold", size: 8))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                Spacer()
            }
            .padding()
        }

    private func classify(image: CVPixelBuffer) {
        do {
            let config = MLModelConfiguration()
            let model = try QuickDrawImageClassifier(configuration: config) // Certifique-se que este nome está certo
            let visionModel = try VNCoreMLModel(for: model.model)

            let request = VNCoreMLRequest(model: visionModel) { (request, error) in

                // DETETIVE 1: O bloco de conclusão foi chamado?
               // print("➡️ 1. Completion handler foi chamado.")

                guard let results = request.results as? [VNClassificationObservation],
                      let topResult = results.first else {
                    
                    // DETETIVE 2: Se o guard falhar, saberemos o porquê.
//                    print("❌ 2. GUARD FALHOU: Os resultados não são do tipo [VNClassificationObservation] ou estão vazios.")
//                    print("   - Tipo de resultado recebido: \(type(of: request.results))")
//                    print("   - Conteúdo dos resultados: \(String(describing: request.results))")

                    DispatchQueue.main.async {
                        self.predictionText = "Não foi possível processar o resultado do modelo."
                    }
                    return
                }
                
                // DETETIVE 3: Se o guard passar, saberemos.
             //   print("✅ 3. GUARD PASSOU: Resultado encontrado - '\(topResult.identifier)' com confiança \(topResult.confidence)")

                let bestPrediction = topResult.identifier
                let confidence = topResult.confidence

                DispatchQueue.main.async {
                    let confidencePercentage = Int(confidence * 100)
                    self.predictionText = "Feitico de \(bestPrediction)? escolhido, (\(confidencePercentage)%)"
                }
            }

            let handler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
            try handler.perform([request])

        } catch {
            // DETETIVE 4: Se qualquer coisa antes da análise der errado, saberemos aqui.
           // print("❗️ 4. ERRO NO BLOCO CATCH: \(error)")
            DispatchQueue.main.async {
                self.predictionText = "Erro ao carregar o modelo ou executar a requisição."
            }
        }
    }
    
       }
//#Preview {
//    ContentView()
//}

struct ContentView_Previes: PreviewProvider{
    static var previews: some View {
        ContentView()
    }
}
