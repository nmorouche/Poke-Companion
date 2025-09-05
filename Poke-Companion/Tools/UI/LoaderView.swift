//
//  LoaderView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 19/07/2023.
//

import SwiftUI
import Lottie

struct LoaderView: View {
    var text: String = "Loading"
    
    var body: some View {
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            
            VStack {
                LottieView(filename: "triopikeur", contentMode: .scaleAspectFill)
                    .frame(width: 200, height: 50)
                Text("Loading...")
                    .font(.custom("AvenirNext-Bold", size: 18))
            }
            .frame(width: 200, height: 100)
            .padding()
            .foregroundColor(.white)
            .tint(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    LoaderView()
}
