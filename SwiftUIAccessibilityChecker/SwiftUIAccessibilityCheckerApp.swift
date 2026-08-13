//
//  SwiftUIAccessibilityCheckerApp.swift
//  SwiftUIAccessibilityChecker
//
//  Created by Azharuddin   on 30/07/26.
//

import SwiftUI

@main
struct SwiftUIAccessibilityCheckerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if CommandLine.arguments.contains("--a11y-scan") {
                        await SwiftUIA11yScanRunner.shared.runAllScreens()
                    }
                }
        }
    }
}
