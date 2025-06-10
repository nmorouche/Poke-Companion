//
//  MenuView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if appState.displayEasterEgg {
                        NavigationLink(destination: EasterEggView()) {
                            Text("Asterion le bon")
                        }
                    }
                    NavigationLink(destination: Text("About us")) {
                        Text("About us")
                    }
                } footer: {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("v.\(AppInfo.versionNumber)")
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle(Tab.menu.navigationTitle)
            .onShake {
                appState.displayEasterEgg.toggle()
            }
        }
    }
}

#Preview {
    MenuView()
        .environmentObject(AppState())
}
