//
//  Tab.swift
//  AppRouter
//
//  Created by Nassim Morouche on 10/06/2025.
//

@testable import AppRouter

enum Tab: String, TabType, CaseIterable {
    case home
    case profile
    case settings
    
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .home:
            "house"
        case .profile:
            "person"
        case .settings:
            "gearshape"
        }
    }
}
