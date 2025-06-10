//
//  Tab.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation

enum Tab: Int {
    case search = 0
    case home = 1
    case menu = 2
    
    var navigationTitle: String {
        switch self {
        case .search:
            return "Search"
        case .home:
            return "Home"
        case .menu:
            return "Menu"
        }
    }
}
