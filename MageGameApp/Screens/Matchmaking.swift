import SwiftUI

struct Matchmaking: View {
    @State var matchFound: Bool
    @State private var goToBattleScreen = false
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
       

        ZStack {

            Image("FullStartbg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.45))

            
            VStack {
                if matchFound {
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .appPastel))
                            .scaleEffect(2)
                        
                        StrokedText(
                                   text: "Prepare for battle",
                                   size: 38,
                                   color: .appPastel,
                                   strokeColor: .black,
                                   strokeWidth: 1
                               )
                    }
                } else {
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .appPastel))
                            .scaleEffect(2)
                        
                        StrokedText(
                                   text: "Finding opponent...",
                                   size: 38,
                                   color: .appPastel,
                                   strokeColor: .black,
                                   strokeWidth: 1
                               )
                    }
                }
            }
        }
        .customBackButton()
        .onAppear {
            if !matchFound {
                    self.matchFound = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        router.path.append(AppRoute.battle)
                    }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    router.path.append(AppRoute.battle)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Matchmaking(matchFound: false)
}
