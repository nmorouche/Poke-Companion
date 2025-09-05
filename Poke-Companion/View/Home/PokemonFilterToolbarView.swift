//
//  PokemonFilterToolbarView.swift
//  Poke-Companion
//
//  Enhanced filter toolbar with expandable types and scroll-responsive design
//

import SwiftUI

struct PokemonFilterToolbarView: View {
    // Bindings from parent view
    @Binding var selectedFilter: PokemonType?
    @Binding var isFilterExpanded: Bool
    
    
    var body: some View {
        VStack(spacing: 12) {
            // Filter header - always visible
            filterHeader
            
            // Main popular types (always visible)
            mainTypesGrid
            
            // Additional types (expandable)
            if isFilterExpanded {
                additionalTypesGrid
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity.combined(with: .scale(scale: 0.95))
                    ))
            }
            
            expandCollapseArrow
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Subviews
    
    private var filterHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Filter by Type")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                if let selectedFilter = selectedFilter {
                    Text("Showing \(selectedFilter.rawValue.capitalized) Pokémon")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }
            }
            
            Spacer()
            
            if selectedFilter != nil {
                clearFilterButton
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }
    
    private var clearFilterButton: some View {
        Button("Clear") {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                selectedFilter = nil
            }
        }
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundColor(.blue)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.blue.opacity(0.1), in: Capsule())
    }
    
    private var mainTypesGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6),
            spacing: 12
        ) {
            ForEach(PokemonType.mainTypes, id: \.self) { type in
                EnhancedTypeFilterView(
                    type: type,
                    isSelected: selectedFilter == type
                ) {
                    selectType(type)
                }
                .scaleEffect(1.0)
            }
        }
    }
    
    private var additionalTypesGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 12) {
            let remainingTypes = PokemonType.allCases.filter { !PokemonType.mainTypes.contains($0) }
            ForEach(remainingTypes, id: \.self) { type in
                EnhancedTypeFilterView(
                    type: type,
                    isSelected: selectedFilter == type
                ) {
                    selectType(type)
                }
            }
        }
    }
    
    private var expandCollapseArrow: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.4)) {
                isFilterExpanded.toggle()
            }
        } label: {
            Image(systemName: "chevron.down")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .frame(width: 54, height: 14)
                .rotationEffect(.degrees(isFilterExpanded ? 180 : 0))
                .animation(.easeInOut(duration: 0.4), value: isFilterExpanded)
        }
    }
    
    // MARK: - Actions
    
    private func selectType(_ type: PokemonType) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            if selectedFilter == type {
                selectedFilter = nil
            } else {
                selectedFilter = type
            }
        }
    }
}

#Preview {
    PokemonFilterToolbarView(
        selectedFilter: .constant(.fire),
        isFilterExpanded: .constant(false)
    )
    .padding()
}
