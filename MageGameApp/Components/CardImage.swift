import Foundation
import SwiftUICore

struct CardImage: View {
    let imageName: String
    let width: CGFloat = 70 // Define a default width for convenience

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: width)
    }
}
