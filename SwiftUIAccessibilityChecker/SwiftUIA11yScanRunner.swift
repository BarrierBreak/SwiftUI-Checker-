//
//  SwiftUIA11yScanRunner.swift
//  SwiftUIAccessibilityChecker
//
//  The app's entire accessibility-scan integration: a list of screens, and one call.
//
//  Everything that used to be here — which workflows run, which technique IDs are
//  reported, how one control's findings are recognised as one control's across a dozen
//  scroll positions, which of two overlapping rules wins, how source lines are resolved,
//  and the whole report format — now lives in the framework, where it can be maintained
//  and fixed once for every app that embeds it. This file names screens. That's all.
//
//  Trigger: launch the app with  --a11y-scan
//           add --a11y-screen=<ViewName> to scan a single screen.
//  Results: printed to the Xcode console AND written to
//           ~/Documents/a11y-demo-report.txt
//

import SwiftUI
import A11yInspectTestCases

enum SwiftUIA11yScan {

    /// Every example screen, in report order.
    static let screens: [A11yScreen] = [
        // Accessible name
        A11yScreen("Pass", AccessibleNamePass()),
        A11yScreen("Fail", AccessibleNameFail()),
        A11yScreen("Partial", AccessibleNamePartial()),
        A11yScreen("Extras Pass", AccessibleNameExtrasPass()),
        A11yScreen("Extras Fail", AccessibleNameExtrasFail()),
        A11yScreen("Extras Partial", AccessibleNameExtrasPartial()),

        // Role — native controls, then hand-built ones. The role rulesets run in the same
        // sweep as the accessible-name ones, so these are scanned by the same pipeline.
        A11yScreen("Native Role Pass", AccessibleNativeRolePass()),
        A11yScreen("Native Role Fail", AccessibleNativeRoleFail()),
        A11yScreen("Native Role Partial", AccessibleNativeRolePartial()),
        A11yScreen("Role Pass", AccessibleRolePass()),
        A11yScreen("Role Fail", AccessibleRoleFail()),
        A11yScreen("Role Partial", AccessibleRolePartial()),

        // State — selected/expanded/checked/disabled/busy/invalid/current, as distinct
        // from NAME or ROLE. See each screen's own doc comment.
        A11yScreen("State Pass", AccessibleStatePass()),
        A11yScreen("State Fail", AccessibleStateFail()),
        A11yScreen("State Partial", AccessibleStatePartial()),

        // Keyboard — hardware-keyboard focus support itself.
        // Resize text and text clipping — WCAG 1.4.4, both answered from source:
        // _UIHostingView has no subviews, so there is no rendered label to measure.
        A11yScreen("Text Resize Pass", AccessibleTextResizePass()),
        A11yScreen("Text Resize Fail", AccessibleTextResizeFail()),
        A11yScreen("Text Resize Partial", AccessibleTextResizePartial()),
        A11yScreen("Text Clipping Pass", AccessibleTextClippingPass()),
        A11yScreen("Text Clipping Fail", AccessibleTextClippingFail()),
        A11yScreen("Text Clipping Partial", AccessibleTextClippingPartial()),

        A11yScreen("Keyboard Pass", AccessibleKeyboardPass()),
        A11yScreen("Keyboard Fail", AccessibleKeyboardFail()),
        A11yScreen("Keyboard Partial", AccessibleKeyboardPartial()),

        // Target size — WCAG 2.5.8. Size is checked first, and the space around a control
        // is only measured when the control is under the 24pt minimum.
        A11yScreen("Target Size Pass", AccessibleTargetSizePass()),
        A11yScreen("Target Size Fail", AccessibleTargetSizeFail()),
        A11yScreen("Target Size Partial", AccessibleTargetSizePartial()),

        // Text contrast — WCAG 1.4.3 on SOLID backgrounds. On SwiftUI the ratio comes out
        // of a screenshot rather than out of two known colours, so these screens are built
        // so the verdict does not depend on where the crop landed.
        A11yScreen("Text Contrast Pass", AccessibleTextContrastPass()),
        A11yScreen("Text Contrast Fail", AccessibleTextContrastFail()),
        A11yScreen("Text Contrast Partial", AccessibleTextContrastPartial()),

        // Composited contrast — the harder half of 1.4.3, where neither colour in the
        // comparison is the one written in the source: opacity on the text or the panel,
        // stacked translucent layers, materials, gradients and images, and the runtime
        // settings (dark mode, Increase Contrast, Dynamic Type) that change the inputs
        // after the fact.
        A11yScreen("Composited Contrast Pass", AccessibleTextContrastCompositedPass()),
        A11yScreen("Composited Contrast Fail", AccessibleTextContrastCompositedFail()),
        A11yScreen("Composited Contrast Partial", AccessibleTextContrastCompositedPartial()),
    ]

    /// Awaited from the app's `.task`, deliberately, rather than fired into a detached
    /// Task: the scan drives SwiftUI's own layout and render passes, and letting the
    /// enclosing task finish first leaves the two interleaving differently on every run —
    /// which showed up as the screenshot-based contrast rules sampling partly-rendered
    /// screens and reporting a different set of ratios each time.
    @MainActor
    /// Narrows the scan to one rule family, via `--a11y-testcases-family=<name>`.
    ///
    /// This is what makes a per-family XCTest readable: a keyboard test asks for the keyboard
    /// family and gets a report with nothing else in it, instead of filtering forty rules'
    /// worth of rows down to six in the assertion. Omitting the argument scans everything.
    static let familyArgument = "--a11y-testcases-family="

    static var requestedFamily: String? {
        guard let arg = CommandLine.arguments.first(where: { $0.hasPrefix(familyArgument) }) else {
            return nil
        }
        return String(arg.dropFirst(familyArgument.count))
    }

    static func runIfRequested() async {
        guard A11yInspectScan.isScanRequested else { return }

        // An unknown family name falls back to the full set rather than scanning nothing: a
        // report of zero rows and a report the argument never reached look identical from a
        // test, and the first is the one that wastes an afternoon.
        var rules: Set<String>?
        if let family = requestedFamily {
            rules = A11yRuleSet.rules(for: family, platform: .swiftUI)
            if rules == nil {
                print("[A11yInspectTestCases] ⚠️ \(familyArgument)\(family) matched no family; scanning all rules instead.")
            }
        }

        await A11yInspectScan.shared.run(platform: .swiftUI, rules: rules, screens: screens)
    }
}
