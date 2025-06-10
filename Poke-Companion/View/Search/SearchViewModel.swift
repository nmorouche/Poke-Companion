//
//  SearchViewModel.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation

final class SearchViewModel: BaseViewModel {
    
    @Published var searchText: String = ""
    @Published var searchType: SearchType = .name
}
