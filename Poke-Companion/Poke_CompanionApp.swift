//
//  Poke_CompanionApp.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 17/07/2023.
//

import SwiftUI
import Injector

@main
struct Poke_CompanionApp: App {
    
    @StateObject var appState = AppState()
    
    init() {
        Locator.register(PokemonService.self, mode: .newInstance) { PokemonService() }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
