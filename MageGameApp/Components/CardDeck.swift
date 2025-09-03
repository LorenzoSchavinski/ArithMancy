//
//  SwiftUIView.swift
//  MageGameApp
//
//  Created by aluno-02 on 27/08/25.
//

import SwiftUI

struct CardDeck: View {
    var body: some View {
        VStack{
            Spacer()
            HStack(spacing: 16){
                Image("sun")
                Image("lightning")
                Image("snowflake")
                
            }
            
        }
        
    }
}

#Preview {
    CardDeck()
}
