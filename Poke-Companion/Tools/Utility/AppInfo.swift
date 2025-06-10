//
//  AppInfo.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation

/// Utility
public enum AppInfo {
    // MARK: - META INFO -

    public static var name: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? ""
    }

    public static var versionNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    public static var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }

    public static var bundleID: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String ?? ""
    }

    // MARK: - APP VARIANTS -

    public static var isBeta: Bool {
        return bundleID.hasSuffix("-beta")
    }

    public static var isDebug: Bool {
        // Micro function, but easier to type + autocompletion.
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    public static var isLaunchedFromXcode: Bool {
        guard let bool = (ProcessInfo().environment["OS_ACTIVITY_DT_MODE"] as NSString?)?.boolValue else { return false }
        return bool
    }

    public static let isRunningTests = NSClassFromString("XCTest") != nil && isDebug
}
