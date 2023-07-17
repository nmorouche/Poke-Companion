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
    
    init() {
        Locator.register(PokemonDetailServiceProtocol.self, mode: .newInstance) { PokemonDetailService() }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
