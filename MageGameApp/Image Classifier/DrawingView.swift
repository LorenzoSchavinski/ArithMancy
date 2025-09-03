//
//  DrawingView.swift
//  MageGameApp
//
//  Created by aluno-02 on 21/08/25.
//

import SwiftUI

// A STRUCT DA LINHA (pode manter como está)
struct Line {
    var points = [CGPoint]()
    var color: Color = .black
    var lineWidth: Double = 5.0
}

// DrawingView AGORA USA BINDINGS
struct DrawingView: View {
    // @Binding cria uma conexão de duas vias com o @State da ContentView.
    @Binding var lines: [Line]
    @Binding var currentLine: Line

    var body: some View {
        
        Canvas { context, size in
            // O código de desenho continua o mesmo...
            for line in lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
            }
            
            var currentPath = Path()
            currentPath.addLines(currentLine.points)
            context.stroke(currentPath, with: .color(currentLine.color), lineWidth: currentLine.lineWidth)
            
        }
        .frame(width: 300, height: 300)
        .border(Color.gray)
        .background(Color.white)
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            // As ações do gesture agora modificam os bindings...
            .onChanged({ value in
                let newPoint = value.location
                // ...que por sua vez modificam o @State na ContentView.
                currentLine.points.append(newPoint)
            })
            .onEnded({ value in
                self.lines.append(currentLine)
                self.currentLine = Line(points: [])
            })
        )
    }
}
//
//#Preview {
//    DrawingView()
//}
