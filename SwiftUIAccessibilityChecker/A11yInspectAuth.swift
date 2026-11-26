//
//  A11yInspectAuth.swift
//  SwiftUIAccessibilityChecker
//
//  Authenticates the A11yInspect framework with an API key — the same way the UIKit
//  checker does it: synchronously, in SceneDelegate, before the scan or the floating
//  button. SwiftUIA11yScanRunner calls it too as a safety net; it is a no-op once the
//  framework is authenticated.
//
//  Key, first match wins:
//    1. the launch argument   --a11y-api-key=<key>
//    2. the environment var   A11Y_API_KEY
//    3. SceneDelegate.apiKey
//

import Foundation
import A11yInspectTestCases

enum A11yInspectAuth {

    static let launchArgumentPrefix = "--a11y-api-key="
    static let environmentKey = "A11Y_API_KEY"

    /// The API key from the first source that has a non-empty one, or nil.
    static var apiKey: String? {
        let fromArgument = CommandLine.arguments
            .first { $0.hasPrefix(launchArgumentPrefix) }
            .map { String($0.dropFirst(launchArgumentPrefix.count)) }
        let fromEnvironment = ProcessInfo.processInfo.environment[environmentKey]

        return [fromArgument, fromEnvironment, SceneDelegate.apiKey]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty }
    }

    /// Validates the key with the A11yInspect backend. Returns true when authenticated.
    /// On failure a scan still runs: A11yInspectScan reports the auth error itself, so a
    /// UI test sees why it got no results instead of timing out.
    @discardableResult
    static func authenticate() -> Bool {
        if FrameworkAuth.shared.isAuthenticated { return true }

        guard let key = apiKey else {
            print("[A11yInspect] ❌ No API key. Set SceneDelegate.apiKey, pass \(launchArgumentPrefix)<key>, or set \(environmentKey).")
            return false
        }

        do {
            try FrameworkAuth.shared.authenticate(apiKey: key)
            print("[A11yInspect] ✅ Authenticated.")
            return true
        } catch {
            print("[A11yInspect] ❌ Framework authentication failed: \(error)")
            return false
        }
    }
}
