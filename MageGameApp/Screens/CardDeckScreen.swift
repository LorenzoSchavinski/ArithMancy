//
//  CardDeckScreen.swift
//  MageGameApp
//
//  Created by aluno-02 on 01/09/25.
//

import SwiftUI

struct CardDeckScreen: View {
    var body: some View {
        
        ZStack{
            Image("FullStartbg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.45))

            VStack{
                StrokedText(
                           text: "Cards Gallery",
                           size: 38,
                           color: .appPastel,
                           strokeColor: .black,
                           strokeWidth: 1
                       )
                Spacer()
            }
            VStack{
                HStack(spacing: 16) {
                    CardImage(imageName: "sun")
                    CardImage(imageName: "lightning")
                    CardImage(imageName: "snowflake")
                    
                }
                    .offset(y: -200)
                    .offset(x: -50)
                    .lineLimit(3)
            }
        }
    }
}

#Preview {
    CardDeckScreen()
}
