//
//  Poke_CompanionApp.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 17/07/2023.
//

import SwiftUI
import AppRouter
import Nuke
import Injector

@main
struct Poke_CompanionApp: App {
    
    @State var router: Router = .init(initialTab: .home)
    
    init() {
        Locator.register(PokemonService.self, mode: .newInstance) { PokemonService() }
        ImagePipeline.shared = ImagePipeline(configuration: .withDataCache)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
        }
    }
}
