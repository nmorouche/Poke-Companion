//
//  Router.swift
//  AppRouter
//
//  Created by Nassim Morouche on 10/06/2025.
//

import Foundation
import SwiftUI

@Observable
@MainActor
public final class AppRouter<Tab: TabType, Destination: DestinationType, Sheet: SheetType> {
    
    private var paths: [Tab: [Destination]] = [:]
    public var selectedTab: Tab
    public var presentedSheet: Sheet?
    
    public init(initialTab: Tab) {
        self.selectedTab = initialTab
    }
    
    public subscript(tab: Tab) -> [Destination] {
        get { paths[tab] ?? [] }
        set { paths[tab] = newValue }
    }
    
    public var selectedTabPath: [Destination] {
        paths[selectedTab] ?? []
    }
    
    public func popToRoot(for tab: Tab? = nil) {
        paths[tab ?? selectedTab] = []
    }
    
    public func popNavigation(for tab: Tab? = nil) {
        let targetTab = tab ?? selectedTab
        if paths[targetTab]?.isEmpty == false {
            paths[targetTab]?.removeLast()
        }
    }
    
    public func navigateTo(_ destination: Destination, for tab: Tab? = nil) {
        let targetTab = tab ?? selectedTab
        if paths[targetTab] == nil {
            paths[targetTab] = [destination]
        } else {
            paths[targetTab]?.append(destination)
        }
    }
    
    public func presentSheet(_ sheet: Sheet) {
        presentedSheet = sheet
    }
    
    public func dismissSheet() {
        presentedSheet = nil
    }
    
    @discardableResult
    public func navigate(to url: URL) -> Bool {
        return URLNavigationHelper.navigate(url: url) { destinations in
            paths[selectedTab] = destinations
        }
    }
    
    @discardableResult
    public func navigate(to urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }
        return navigate(to: url)
    }
}
