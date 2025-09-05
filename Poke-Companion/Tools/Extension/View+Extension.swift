//
//  View+Extension.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 17/07/2023.
//

import SwiftUI
import Metal

extension View {
    func circleLoader(seconds: Double) -> some View {
        self
            .colorEffect(
                ShaderLibrary.default.circleLoader(.boundingRect, .float(seconds))
            )
    }
    
    func withAppDestination() -> some View {
        modifier(AppDestination())
    }
}
