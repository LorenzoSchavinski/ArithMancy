//
//  MageGameAppApp.swift
//  MageGameApp
//
//  Created by aluno-02 on 21/08/25.


import SwiftUI

final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
}

enum AppRoute: Hashable {
    case modeSelector
    case stats
    case matchmaking(found: Bool)
    case battle
    case gallery
}

@main
struct MageGameAppApp: App {
    @StateObject private var router = NavigationRouter()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                StartScreen()
               // WizardSpells(spellName: "sun", isEnemy: false)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .modeSelector:
                            ModeSelector()
                        case .stats:
                            StatsScreen()
                         case .gallery:
                            TabBar()
                        case .matchmaking(let found):
                            Matchmaking(matchFound: found)
                        case .battle:
                            BattleScreen()
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}

//import SwiftUI
//
//final class NavigationRouter: ObservableObject {
//    @Published var path = NavigationPath()
//}
//
//enum AppRoute: Hashable {
//    case modeSelector
//    case stats
//    case matchmaking(found: Bool)
//    case battle
//    case gallery
//}
//@main
//struct MageGameAppApp: App {
//    var body: some Scene {
//        WindowGroup {
//           // aaa(health:.constant(3))
//            ///BattleScreen()
//           /// StartScreen()
//            /// aaa
//            GalleryScreen()
//
//        }
//    }
//}
