//
//  RootView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            SearchView()
                .tabItem {
                    Label(Tab.search.navigationTitle, systemImage: "magnifyingglass")
                }
                .environmentObject(appState)
                .tag(Tab.search)
            
            HomeView()
                .tabItem {
                    Label(Tab.home.navigationTitle, systemImage: "house")
                }
                .environmentObject(appState)
                .tag(Tab.home)
            
            MenuView()
                .tabItem {
                    Label(Tab.menu.navigationTitle, systemImage: "ellipsis")
                }
                .environmentObject(appState)
                .tag(Tab.menu)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
