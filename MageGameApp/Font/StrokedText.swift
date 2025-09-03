import SwiftUI

struct StrokedText: View {
    let text: String
    let size: CGFloat
    let color: Color
    let strokeColor: Color
    let strokeWidth: CGFloat

    var body: some View {
        ZStack {
            // Outline
            Text(text)
                .font(.custom("PixelifySans-Bold", size: size))
                .offset(x:  strokeWidth, y:  strokeWidth)
                .foregroundColor(strokeColor)
            
            Text(text)
                .font(.custom("PixelifySans-Bold", size: size))
                .offset(x: -strokeWidth, y: -strokeWidth)
                .foregroundColor(strokeColor)
            
            Text(text)
                .font(.custom("PixelifySans-Bold", size: size))
                .offset(x: -strokeWidth, y:  strokeWidth)
                .foregroundColor(strokeColor)
            
            Text(text)
                .font(.custom("PixelifySans-Bold", size: size))
                .offset(x:  strokeWidth, y: -strokeWidth)
                .foregroundColor(strokeColor)
            
            // Fill
            Text(text)
                .font(.custom("PixelifySans-Bold", size: size))
                .foregroundColor(color)
        }
    }
}
