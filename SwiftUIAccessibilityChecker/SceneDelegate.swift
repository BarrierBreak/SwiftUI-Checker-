//
//  SceneDelegate.swift
//  SwiftUIAccessibilityChecker
//
//  Same flow as the UIKit checker's SceneDelegate:
//    1. authenticate the framework (before any scan),
//    2. if a UI test launched the app with --a11y-testcases-scan, leave the window to
//       the scan (SwiftUIA11yScan.runIfRequested, awaited from ContentView's .task),
//    3. otherwise add the floating scan button.
//  Hooked up by OrientationAppDelegate's application(_:configurationForConnecting:options:).
//

import UIKit
import A11yInspectTestCases

final class SceneDelegate: NSObject, UIWindowSceneDelegate {

    /// A11yInspect API key. A --a11y-api-key=<key> launch argument or the A11Y_API_KEY
    /// environment variable overrides it (handy for CI).
    static let apiKey = "ak_akZga9OES04sz88NMW7V61ForR6g7IyLHpUvBWhHYDs"

    var window: UIWindow?
    private var floatingButton: AccessibilityFloatingButton?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // Framework authentication — before any scan, exactly as in the UIKit app.
        A11yInspectAuth.authenticate()

        // Automated scan requested by XCTest: no floating button over it.
        if A11yInspectScan.isScanRequested { return }

        // SwiftUI creates its window after this call returns, so add the button on the
        // next run-loop pass.
        DispatchQueue.main.async { [weak self] in
            self?.attachFloatingButton(to: windowScene)
        }
    }

    private func attachFloatingButton(to windowScene: UIWindowScene) {
        guard floatingButton == nil,
              let window = window ?? windowScene.keyWindow ?? windowScene.windows.first else {
            return
        }
        self.window = window

        let button = AccessibilityFloatingButton(
            rootViewProvider: { [weak window] in window?.rootViewController?.view },
            rootViewControllerProvider: { [weak window] in window?.rootViewController }
        )
        button.frame = CGRect(
            x: window.bounds.width - 80,
            y: window.bounds.height - 150,
            width: 60,
            height: 60
        )
        window.addSubview(button)
        window.bringSubviewToFront(button)
        floatingButton = button
    }
}
