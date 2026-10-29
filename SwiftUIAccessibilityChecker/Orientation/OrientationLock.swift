import SwiftUI
import UIKit

/// SwiftUI has no per-screen orientation setting, so an app restricts one through the app
/// delegate's `supportedInterfaceOrientationsFor`, which is what the framework reads.
final class OrientationAppDelegate: NSObject, UIApplicationDelegate {

    /// What the screen on display allows. `.all` unless a screen has asked otherwise.
    static var allowed: UIInterfaceOrientationMask = .all

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        Self.allowed
    }
}

extension View {
    /// Holds the screen to `mask` while it is on display, and releases it afterwards.
    func orientationLock(_ mask: UIInterfaceOrientationMask) -> some View {
        onAppear { OrientationAppDelegate.allowed = mask }
            .onDisappear { OrientationAppDelegate.allowed = .all }
    }
}
