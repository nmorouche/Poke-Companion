//
//  RootView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import SwiftUI
import AppRouter

struct AppTabView: View {
    @Environment(Router.self) var router
    let tab: AppTab
    
    var body: some View {
        @Bindable var router = router
        
        GeometryReader { geometry in
            NavigationStack(path: $router[tab]) {
                switch tab {
                case .home:
                    HomeView()
                        .withAppDestination()
                case .search:
                    SearchView()
                        .withAppDestination()
                case .settings:
                    SettingsView()
                        .withAppDestination()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    AppTabView(tab: .home)
        .environment(Router(initialTab: .search))
}
