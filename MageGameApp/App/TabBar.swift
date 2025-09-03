import SwiftUI

struct TabBar: View {
    init() {
        // --- Configuração da Aparência da Tab Bar ---
        // Deixa a barra de abas com um fundo preto e 40% de opacidade
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = nil // Remove o efeito de blur
        appearance.backgroundColor = UIColor(Color.appBlack).withAlphaComponent(0.4)
        appearance.shadowColor = .clear // Remove a linha superior
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
        
        // --- Configuração da Aparência da Navigation Bar ---
        // Garante que a barra de navegação superior (onde fica o botão "Back") também seja transparente
        let nav = UINavigationBarAppearance()
        nav.configureWithTransparentBackground()
        nav.backgroundEffect = nil
        nav.backgroundColor = .clear
        nav.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
    }
    
    // Função para voltar para a tela anterior
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TabView {
            // 1) Aba de Magos
            WizardGallery()
                .tabItem {
                    Label("Wizards", image: "wizardHat")
                }

            // 2) Aba de Feitiços
            SpellsScreen()
                .tabItem {
                    Label("Spells", systemImage: "wand.and.stars")
                }

            // 3) Aba de Cartas
            CardDeckScreen()
                .tabItem {
                    Label("Cards", systemImage: "scroll")
                }
        }
        // Adiciona o fundo principal à tela inteira
        .background(
            Image("FullStartbg")
                .resizable()
                .scaledToFill()
                .overlay(Color.black.opacity(0.45))
                .ignoresSafeArea()
        )
        // Cria o botão de voltar personalizado
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.custom("PixelifySans-SemiBold", size: 24))
                        
                        Text("Back")
                            .font(.custom("PixelifySans-SemiBold", size: 24))
                    }
                    .foregroundColor(.appPastel)
                }
            }
        }
    }
}

#Preview {
    // Para ter uma prévia realista, é bom colocar dentro de uma NavigationStack
    NavigationStack {
        TabBar()
    }
}
