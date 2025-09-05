//
//  AppInfo.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation

/// Utility
enum AppInfo {
    // MARK: - META INFO -

    static var name: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? ""
    }

    static var versionNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    static var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }

    static var bundleID: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String ?? ""
    }

    // MARK: - APP VARIANTS -

    static var isBeta: Bool {
        return bundleID.hasSuffix("-beta")
    }

    static var isDebug: Bool {
        // Micro function, but easier to type + autocompletion.
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static var isLaunchedFromXcode: Bool {
        guard let bool = (ProcessInfo().environment["OS_ACTIVITY_DT_MODE"] as NSString?)?.boolValue else { return false }
        return bool
    }

    static let isRunningTests = NSClassFromString("XCTest") != nil && isDebug
}
