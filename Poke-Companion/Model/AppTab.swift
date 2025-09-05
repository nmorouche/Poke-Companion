//
//  AppTab.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 11/06/2025.
//

import AppRouter
import SwiftUI

enum AppTab: String, TabType {
    case home
    case settings
    case search
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: "Home"
        case .search: "Search"
        case .settings: "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home: "house"
        case .search: "magnifyingglass"
        case .settings: "gearshape"
        }
    }
}
