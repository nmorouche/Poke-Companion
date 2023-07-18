//
//  AppState.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation

final class AppState: ObservableObject {
    
    @Published var selectedTab: Tab = .home {
        didSet {
            if oldValue == selectedTab {
                // TODO: - Add logic when clicking multiple times on the same tab to reset it (reset all navigation links)
                switch selectedTab {
                default:
                    break
                }
            }
        }
    }
}
