//
//  View+Extension.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 17/07/2023.
//

import SwiftUI

extension View {
    func
    circleLoader(seconds: Double) -> some View {
        self
            .colorEffect(
                ShaderLibrary.default.circleLoader(.boundingRect, .float(seconds))
            )
    }
}
