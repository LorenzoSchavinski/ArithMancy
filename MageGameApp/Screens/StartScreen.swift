//
//  StartScreen.swift
//  MageGameApp
//
//  Created by aluno-02 on 22/08/25.
//

import SwiftUI

struct StartNavLink: ViewModifier {
    @EnvironmentObject var router: NavigationRouter
    let route: AppRoute
    func body(content: Content) -> some View {
        content.onTapGesture { router.path.append(route) }
    }
}

struct StartScreen: View {
    
    var body: some View {
        
        
        
        
        
        // Navigation gerenciada no App root
        ZStack{
            
            
            Image("FullStartbg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(){
                
                StrokedText(
                    text: "Arithmancy",
                    size: 48,
                    color: .appPastel,
                    strokeColor: .black,
                    strokeWidth: 2
                )
                
                Spacer()
                ZStack{
                    Image("Botao")
                    Text("PLAY")
                        .foregroundColor(.appTree)
                        .font(.custom("PixelifySans-SemiBold", size: 30))
                }
                    .modifier(StartNavLink(route: .modeSelector))
                
                
                ZStack{
                    Image("Botao")
                    Text("STATS")
                        .foregroundColor(.appTree)
                        .font(.custom("PixelifySans-SemiBold", size: 30))
                }
                .modifier(StartNavLink(route: .stats))
                ZStack{
                    Image("Botao")
                    Text("GALLERY")
                        .foregroundColor(.appTree)
                        .font(.custom("PixelifySans-SemiBold", size: 26))
                }
                .modifier(StartNavLink(route: .gallery))
                Spacer()
            }
        }
    }
    
}


#Preview {
    StartScreen()
}
