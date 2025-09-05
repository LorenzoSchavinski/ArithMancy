//
//  ImageHelpers.swift
//  MageGameApp
//
//  Created by aluno-02 on 21/08/25.
//

import UIKit
import VideoToolbox // conversão de imagem

extension UIImage {
    
    /// Redimensiona a imagem para um tamanho específico e a converte para um CVPixelBuffer.
    /// - Parameters:
    ///   - width: A largura da imagem de saída em pixels.
    ///   - height: A altura da imagem de saída em pixels.
    /// - Returns: Um CVPixelBuffer pronto para ser usado pelo Core ML, ou nil se a conversão falhar.
    func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        
        let newSize = CGSize(width: width, height: height)
        let imageRenderer = UIGraphicsImageRenderer(size: newSize)
        
        let resizedImage = imageRenderer.image { _ in
            // O 'draw' redimensiona a imagem original para caber no novo tamanho.
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        guard let finalImage = resizedImage.cgImage else {
            return nil
        }
        
        // --- ETAPA 2: Converter para CVPixelBuffer ---
        var pixelBuffer: CVPixelBuffer?
        
        // Cria o CVPixelBuffer.
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          finalImage.width,
                                          finalImage.height,
                                          kCVPixelFormatType_32BGRA,
                                          nil,
                                          &pixelBuffer)
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        // Bloqueia a memória do buffer para podermos escrever os pixels nele.
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        
        // Cria um contexto de desenho que aponta diretamente para a memória do buffer.
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: finalImage.width,
                                      height: finalImage.height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        else {
            return nil
        }
        
        context.draw(finalImage, in: CGRect(x: 0, y: 0, width: finalImage.width, height: finalImage.height))
        
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return buffer
    }
}
