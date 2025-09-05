//
//  DestinationType.swift
//  AppRouter
//
//  Created by Nassim Morouche on 10/06/2025.
//

public protocol DestinationType: Hashable {
    static func from(path: String, fullPath: [String], parameters: [String: String]) -> Self?
}
