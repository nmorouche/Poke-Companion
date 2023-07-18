//
//  EasterEggView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import SwiftUI

struct EasterEggView: View {
    
    let assets: [String] = ["asterion1", "asterion2", "asterion3"]
    
    var body: some View {
        TabView {
            ForEach(assets, id: \.self) { asset in
                Image(asset)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationTitle("AS Minotaur")
    }
}

#Preview {
    EasterEggView()
}
