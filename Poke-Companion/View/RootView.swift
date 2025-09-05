//
//  Untitled.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 11/06/2025.
//

import SwiftUI
import AppRouter

struct RootView: View {
    @Environment(Router.self) var router
    let tabs: [AppTab] = AppTab.allCases
    
    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            ForEach(tabs) { tab in
                Tab(value: tab, role: tab == .search ? .search : .none) {
                    AppTabView(tab: tab)
                } label: {
                    Label(tab.title, systemImage: tab.icon)
                }
            }
        }
        .tint(.black)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}
