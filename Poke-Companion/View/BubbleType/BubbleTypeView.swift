//
//  BubbleTypeView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 19/07/2023.
//

import SwiftUI

struct BubbleTypeView: View {
    
    let type: PokemonType
    var fontSize: CGFloat = 11.0
    
    var body: some View {
        VStack {
            Text(type.rawValue.capitalized)
                .font(.custom("AvenirNext-Bold", size: fontSize))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(hex: type.colorCode))
                        .stroke(.white.opacity(0.4), lineWidth: 0.5)
                        .glassEffect()
                )
        }
    }
}

#Preview {
    BubbleTypeView(type: .dragon)
}
