//
//  SwiftUIView.swift
//  MageGameApp
//
//  Created by aluno-02 on 25/08/25.
//

import SwiftUI

struct BombTick: View {
    @Binding var turnArrow : Bool
    var body: some View {
        
        ZStack{
            Image("hourglass")
            
           
                
                if turnArrow{
                    Image("Turn Arrow left")
                         .offset(x: -40)
                         .scaleEffect(1.5)
                         .frame(width: 80, height: 80)

                }else{
                    Image("Turn Arrow right")
                        .offset(x: 40)
                        .scaleEffect(1.5)
                        .frame(width: 80, height: 80)
                   

                }

            }
        .frame(width: 120, height: 120)
        //.clipped()
        }
        
    }
    

//struct BombTick: View {
//    @Binding var turnArrow: Bool
//
//    var body: some View {
//        ZStack {
//            Image("hourglass")
//                //.resizable()
//               // .scaledToFit()
//
//            (turnArrow ? Image("Turn Arrow left") : Image("Turn Arrow right"))
//                .resizable()
//                .scaledToFit()
//                .frame(width: 80, height: 80)       // seta com tamanho fixo
//                .offset(x: turnArrow ? -40 : 40)
//                .scaleEffect(1.5)
//        }
//        .frame(width: 120, height: 120)              // slot fixo do BombTick
//        .clipped()
//    }
//}


#Preview {
    BombTick(turnArrow: .constant(true))
    
}
