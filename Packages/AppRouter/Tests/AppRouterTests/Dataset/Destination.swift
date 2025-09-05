//
//  Destination.swift
//  AppRouter
//
//  Created by Nassim Morouche on 10/06/2025.
//

@testable import AppRouter

enum Destination: DestinationType {
    case note(String)
    case all
    case article(String)
    
    // protocol func
    static func from(path: String, fullPath: [String], parameters: [String: String]) -> Destination? {
        guard let currentIndex = fullPath.firstIndex(of: path) else { return nil }
        
        let previousView = currentIndex > 0 ? fullPath[currentIndex - 1] : nil
        
        switch (previousView, path) {
        case (_, "all"):
            return .all
        case ("article", "id"):
            let articleId = parameters["id"] ?? "unknown"
            return .article(articleId)
        case (_, "note"):
            if let id = parameters["id"] {
                return .note(id)
            }
            return .note("default")
        case (nil, "article"), (nil, "note"):
            return nil
        default:
            return nil
        }
    }
}
