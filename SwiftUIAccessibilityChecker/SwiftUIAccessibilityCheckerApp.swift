//
//  SwiftUIAccessibilityCheckerApp.swift
//  SwiftUIAccessibilityChecker
//
//  Created by Azharuddin   on 30/07/26.
//

import SwiftUI

@main
struct SwiftUIAccessibilityCheckerApp: App {
    @UIApplicationDelegateAdaptor(OrientationAppDelegate.self) private var orientationDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { await SwiftUIA11yScan.runIfRequested() }
        }
    }
}
