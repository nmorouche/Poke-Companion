//
//  RouterDestination.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 11/06/2025.
//

import AppRouter

enum RouterDestination: DestinationType, Hashable {
    static func from(path: String, fullPath: [String], parameters: [String : String]) -> RouterDestination? {
        nil
    }
    
    case detail(Pokemon)
    case about
}
