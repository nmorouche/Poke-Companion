//
//  PokemonDetailView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 12/06/2025.
//

import SwiftUI
import AppRouter

struct PokemonDetailView: View {
    
    @Environment(Router.self) var router
    @StateObject var viewModel: PokemonDetailViewModel
    
    /// Computed properties
    var maxAnimationDuration: CGFloat {
        return isiOS26 ? 0.25 : 0.18
    }
    
    var animation: Animation {
        .interpolatingSpring(duration: animationDuration, bounce: 0, initialVelocity: 0)
    }
    
    /// Bottom Sheet Properties
    @State private var showBottomSheet: Bool = true
    @State private var sheetDetent: PresentationDetent = .height(350)
    @State private var sheetHeight: CGFloat = 0
    @State private var animationDuration: CGFloat = 0
    @State private var toolbarOpacity: CGFloat = 1
    @State private var safeAreaBottomInset: CGFloat = 0
    @State private var selectedTab: PokemonDetailTab = .about
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: .init(pokemon: pokemon))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with navigation
            HStack {
                Button {
                    // First dismiss the sheet, then navigate back
                    showBottomSheet = false
                    router.popNavigation()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button { } label: {
                    Image(systemName: "heart")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            
            // Pokemon info section
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.pokemon.name.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 8) {
                        ForEach(viewModel.pokemon.types) { type in
                            BubbleTypeView(type: type, fontSize: 12)
                        }
                    }
                }
                
                Spacer()
                
                Text("#\(String(format: "%03d", viewModel.pokemon.id))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            // Pokemon image centered
            ZStack {
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .offset(y: 25)
                
                CustomAsyncImage(url: viewModel.pokemon.url, width: 200, height: 200)
            }
            .padding(.bottom, 60)
            
            Spacer()
        }
        .sheet(isPresented: $showBottomSheet) {
            bottomSheet
            .presentationDetents([.height(350), .large], selection: $sheetDetent)
            .presentationBackgroundInteraction(.enabled)
            .presentationCornerRadius(isiOS26 ? nil : 30)
            .presentationBackground {
                if !isiOS26 {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onGeometryChange(for: CGFloat.self) {
                max(min($0.size.height, 400 + safeAreaBottomInset), 0)
            } action: { oldValue, newValue in
                /// Limiting the offset to 300, so that opacity effect will be visible
                sheetHeight = min(newValue, 350 + safeAreaBottomInset)
                
                /// Calculating Animation Duration
                let diff = abs(newValue - oldValue)
                let duration = max(min(diff / 100, maxAnimationDuration), 0)
                animationDuration = duration
            }
            .ignoresSafeArea()
            .interactiveDismissDisabled()
        }
        .onGeometryChange(for: CGFloat.self, of: {
            $0.safeAreaInsets.bottom
        }, action: { newValue in
            safeAreaBottomInset = newValue
        })
        .ignoresSafeArea()
        .background(Color(hex: viewModel.pokemon.types.first?.colorCode ?? "#7AC74C"))
        .navigationBarBackButtonHidden()
    }
    
    
    private var bottomSheet: some View {
        VStack {
            
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            pokemonDetailBottomTabs
        }
    }
    
    private var pokemonDetailBottomTabs: some View {
        VStack(spacing: 0) {
            // Tabs
            HStack(spacing: 32) {
                ForEach(PokemonDetailTab.allCases, id: \.self) { tab in
                    TabButton(
                        title: tab.rawValue,
                        isSelected: selectedTab == tab
                    ) {
                        selectedTab = tab
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    switch selectedTab {
                    case .about:
                        aboutContent
                    case .baseStats:
                        BaseStatsView(stats: viewModel.pokemon.stats)
                    case .evolution:
                        Text("Evolution content coming soon...")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .padding(.top, 40)
                            .padding(.horizontal, 24)
                    case .moves:
                        Text("Moves content coming soon...")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .padding(.top, 40)
                            .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 100)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var aboutContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            StatRow(label: "Species", value: "Seed")
            StatRow(label: "Height", value: "\(viewModel.pokemon.height) m")
            StatRow(label: "Weight", value: "\(viewModel.pokemon.weight) kg")
            StatRow(label: "Abilities", value: viewModel.pokemon.abilities.filter({ !$0.is_hidden }).map { $0.ability.name.capitalized }.joined(separator: ", "))
            StatRow(label: "Hidden Abilities", value: viewModel.pokemon.abilities.filter({ $0.is_hidden }).map { $0.ability.name.capitalized }.joined(separator: ", "))
            
            Text("Breeding")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .padding(.top, 16)
            
            StatRow(label: "Gender", value: "♂ 87.5%    ♀ 12.5%")
            StatRow(label: "Egg Groups", value: "Monster")
            StatRow(label: "Egg Cycle", value: "Grass")
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 120)
    }
}

#Preview {
    PokemonDetailView(pokemon: .mockedPokemon)
}

extension View {
    var isiOS26: Bool {
        if #available(iOS 26, *) {
            return true
        }
        
        return false
    }
}
