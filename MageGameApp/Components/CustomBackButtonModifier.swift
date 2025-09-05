import Foundation
import SwiftUI

struct CustomBackButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
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
                        .foregroundColor(.appPastel) 
                    }
                }
            }
    }
}

extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButtonModifier())
    }
}
