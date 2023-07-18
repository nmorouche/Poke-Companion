//
//  Pokemon.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let order: Int
    var url: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/\(id).png"
    }
}
