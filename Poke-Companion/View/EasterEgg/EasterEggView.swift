//
//  EasterEggView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import SwiftUI

struct EasterEggView: View {
    
    @StateObject var viewModel: EasterEggViewModel = .init()
    
    var body: some View {
        TabView {
            ForEach(viewModel.assets, id: \.self) { asset in
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
