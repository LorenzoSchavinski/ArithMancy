import SwiftUI

struct WizardGallery: View {
    @State private var useRed = false
    private var color: String { useRed ? "Red" : "Blue" }
    private func sheet(_ base: String) -> String { "\(base)\(color)Sprite" }
    private var nudgeX: CGFloat { useRed ? 15 : -15 } // mesmo ajuste que você usava no idle

    var body: some View {
        ZStack {
            Image("FullStartbg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.45))

            VStack{
                StrokedText(
                           text: "Wizard Gallery",
                           size: 38,
                           color: .appPastel,
                           strokeColor: .black,
                           strokeWidth: 1
                       )
                Spacer()
            }
            
        
            VStack() {
                Spacer()
                HStack() {
                    
                    Button(action: { useRed.toggle() }) {
                        ZStack {
                            Image("Botao")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140)
                                Text(useRed ? "Show Blue" : "Show Red")
                                    .font(.custom("PixelifySans-SemiBold", size: 20))
                                    .foregroundColor(.appTree)
                        }
                    }
                    //.frame(maxHeight: 300)
                    //Spacer()
                    .offset(y: -10)
                }
            }

            HStack(alignment: .center, spacing: 0) {
                if useRed { Spacer(minLength: 0) }

                VStack(spacing: 16) {
                    // IDLE
                    WizardFactory.makeSpriteSheet(
                        imageName: sheet("idle"),
                        columns: 4, rows: 1, rowIndex: 0,
                        frameCount: 4, fps: 5.0, nodeScale: 4.0
                    )
                    .id(sheet("idle"))
                    .offset(x: nudgeX)

                    // HURT
                    WizardFactory.makeSpriteSheet(
                        imageName: sheet("hurt"),
                        columns: 3, rows: 1, rowIndex: 0,
                        frameCount: 3, fps: 4.0, nodeScale: 4.0
                    )
                    .id(sheet("hurt"))

                    // PASS
                    WizardFactory.makeSpriteSheet(
                        imageName: sheet("pass"),
                        columns: 4, rows: 1, rowIndex: 0,
                        frameCount: 4, fps: 5.0, nodeScale: 4.0
                    )
                    .id(sheet("pass"))

                    // SPELL
                    WizardFactory.makeSpriteSheet(
                        imageName: sheet("spell"),
                        columns: 6, rows: 1, rowIndex: 0,
                        frameCount: 6, fps: 4.0, nodeScale: 4.0
                    )
                    .id(sheet("spell"))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)

                if !useRed { Spacer(minLength: 0) }
            }
            .frame(maxWidth: 370, alignment: useRed ? .trailing : .leading)
            .animation(.easeInOut(duration: 0.2), value: useRed)
        }
      
    }
}

#Preview { WizardGallery() }
