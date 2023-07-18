//
//  MenuView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
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
        }
    }
}

#Preview {
    MenuView()
}
