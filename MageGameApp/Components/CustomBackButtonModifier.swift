import Foundation
import SwiftUI

// 1. O ViewModifier que contém a lógica do botão
struct CustomBackButtonModifier: ViewModifier {
    // Acesso à função de dispensar a tela (voltar)
    @Environment(\.dismiss) private var dismiss

    // A correção está aqui: 'view' foi trocado por 'View'
    func body(content: Content) -> some View {
        content // 'content' é a view onde você aplica o modificador
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.custom("PixelifySans-SemiBold", size:24))

                            Text("Back")
                                .font(.custom("PixelifySans-SemiBold", size: 24))
                        }
                        .foregroundColor(.appPastel) // Sua cor personalizada
                    }
                }
            }
    }
}

// 2. Uma extensão para tornar a chamada mais fácil e limpa
extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButtonModifier())
    }
}
