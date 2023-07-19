//
//  LoaderView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 19/07/2023.
//

import SwiftUI

struct LoaderView: View {
    var text: String = "Loading"
    
    var body: some View {
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            
            ProgressView(label: {
                Text(text)
                    .font(.custom("AvenirNext-Medium", size: 14))
            })
            .progressViewStyle(.circular)
            .padding()
            .background(.white)
            .foregroundColor(.black)
            .tint(.black)
            .cornerRadius(10)
        }
    }
}

#Preview {
    LoaderView()
}
