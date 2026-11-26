//
//  A11yInspectAuth.swift
//  SwiftUIAccessibilityChecker
//
//  Authenticates the A11yInspect framework with an API key. A11yInspectScan.run refuses
//  to scan until FrameworkAuth has validated a key, so this runs before every scan.
//
//  The key is never committed. It is read, first match wins, from:
//    1. the launch argument   --a11y-api-key=<key>
//    2. the environment var   A11Y_API_KEY
//    3. A11yInspectAPIKey.plist (key "APIKey") in the app bundle — gitignored; copy
//       A11yInspectAPIKey.example.plist from the repo root into SwiftUIAccessibilityChecker/
//

import Foundation
import A11yInspectTestCases

enum A11yInspectAuth {

    static let launchArgumentPrefix = "--a11y-api-key="
    static let environmentKey = "A11Y_API_KEY"
    static let plistName = "A11yInspectAPIKey"
    static let plistKey = "APIKey"

    /// The API key from the first source that has a non-empty one, or nil.
    static var apiKey: String? {
        let fromArgument = CommandLine.arguments
            .first { $0.hasPrefix(launchArgumentPrefix) }
            .map { String($0.dropFirst(launchArgumentPrefix.count)) }
        let fromEnvironment = ProcessInfo.processInfo.environment[environmentKey]
        let fromPlist = Bundle.main.url(forResource: plistName, withExtension: "plist")
            .flatMap { NSDictionary(contentsOf: $0)?[plistKey] as? String }

        return [fromArgument, fromEnvironment, fromPlist]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty }
    }

    /// Validates the key with the A11yInspect backend. Returns true when authenticated.
    /// On failure the scan still runs: A11yInspectScan reports the auth error itself, so a
    /// UI test sees why it got no results instead of timing out.
    @discardableResult
    static func authenticate() async -> Bool {
        if FrameworkAuth.shared.isAuthenticated { return true }

        guard let key = apiKey else {
            print("[A11yInspect] ❌ No API key. Pass \(launchArgumentPrefix)<key>, set \(environmentKey), or add \(plistName).plist to the app.")
            return false
        }

        // FrameworkAuth.authenticate blocks on a network call; keep it off the main thread.
        let error: Error? = await Task.detached {
            do {
                try FrameworkAuth.shared.authenticate(apiKey: key)
                return nil
            } catch {
                return error
            }
        }.value

        if let error {
            print("[A11yInspect] ❌ Authentication failed: \(error.localizedDescription)")
            return false
        }
        print("[A11yInspect] ✅ Authenticated.")
        return true
    }
}
