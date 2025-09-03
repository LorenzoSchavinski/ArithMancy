//
//  ModeSelector.swift
//  MageGameApp
//
//  Created by aluno-02 on 22/08/25.
//

import SwiftUI
 
struct ModeNavLink: ViewModifier {
    @EnvironmentObject var router: NavigationRouter
    let route: AppRoute
    func body(content: Content) -> some View {
        content.onTapGesture { router.path.append(route) }
    }
}

struct ModeSelector: View {
    var body: some View {
        ZStack{
                Image("FullStartbg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .foregroundColor(.black)
                    .overlay(
                        Color.black.opacity(0.45) 
                            )
                VStack(){
                    
                    StrokedText(
                               text: "Arithmancy",
                               size: 48,
                               color: .appPastel,
                               strokeColor: .black,
                               strokeWidth: 2
                           )
                    
                    Spacer()
                    
                    HStack(spacing: 16){
                        Image("Matchmaking button")
                            .modifier(ModeNavLink(route: .matchmaking(found: false)))
                        
                        Image("VsIa button")
                            .modifier(ModeNavLink(route: .matchmaking(found: true)))
                        
                        
                    }
                   
                    
                    Spacer()
                }
        }
        .customBackButton()
    
    }
}
    


#Preview {
    ModeSelector()
}
