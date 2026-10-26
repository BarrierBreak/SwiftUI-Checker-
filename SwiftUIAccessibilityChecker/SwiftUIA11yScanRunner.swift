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

        // Hidden from screen reader — decided from the source, because SwiftUI never hands a
        // hidden view to the accessibility tree.
        A11yScreen("Hidden Pass", AccessibleHiddenPass()),
        A11yScreen("Hidden Fail", AccessibleHiddenFail()),
        A11yScreen("Hidden Partial", AccessibleHiddenPartial()),

        // Language — whether the app has one, and whether each piece of text declares a
        // language that agrees with the text and the app.
        A11yScreen("Language Pass", AccessibleLanguagePass()),
        A11yScreen("Language Fail", AccessibleLanguageFail()),
        A11yScreen("Language Partial", AccessibleLanguagePartial()),

        // Motion — a shake-handled action needs an on-screen alternative control.
        A11yScreen("Motion Pass", AccessibleMotionPass()),
        A11yScreen("Motion Fail", AccessibleMotionFail()),
        A11yScreen("Motion Partial", AccessibleMotionPartial()),

        // Images — the text alternative of each picture exposed to VoiceOver.
        A11yScreen("Images Pass", AccessibleImagesPass()),
        A11yScreen("Images Fail", AccessibleImagesFail()),
        A11yScreen("Images Partial", AccessibleImagesPartial()),

        // Reading order — whether the order VoiceOver follows matches the layout.
        A11yScreen("Reading Order Pass", AccessibleReadingOrderPass()),
        A11yScreen("Reading Order Fail", AccessibleReadingOrderFail()),
        A11yScreen("Reading Order Partial", AccessibleReadingOrderPartial()),

        // Focus indicator — the ring a field draws: its contrast, and whether it is more than a
        // colour. Judged from source: SwiftUI draws the ring in a display list.
        A11yScreen("Focus Pass", AccessibleFocusPass()),
        A11yScreen("Focus Fail", AccessibleFocusFail()),
        A11yScreen("Focus Partial", AccessibleFocusPartial()),

        // Links — an inline link set apart from its text by more than colour.
        A11yScreen("Link Pass", AccessibleLinkPass()),
        A11yScreen("Link Fail", AccessibleLinkFail()),
        A11yScreen("Link Partial", AccessibleLinkPartial()),

        // Role trait, state trait, button, form label, custom action and touch event — judged from
        // source (the linter's bundled findings), because SwiftUI keeps these decisions out of the tree.
        A11yScreen("Role trait Pass", AccessibleRoleTraitPass()),
        A11yScreen("Role trait Fail", AccessibleRoleTraitFail()),
        A11yScreen("Role trait Partial", AccessibleRoleTraitPartial()),
        A11yScreen("State trait Pass", AccessibleStateTraitPass()),
        A11yScreen("State trait Fail", AccessibleStateTraitFail()),
        A11yScreen("State trait Partial", AccessibleStateTraitPartial()),
        A11yScreen("Button Pass", AccessibleButtonPass()),
        A11yScreen("Button Fail", AccessibleButtonFail()),
        A11yScreen("Button Partial", AccessibleButtonPartial()),
        A11yScreen("Form label Pass", AccessibleFormLabelPass()),
        A11yScreen("Form label Fail", AccessibleFormLabelFail()),
        A11yScreen("Form label Partial", AccessibleFormLabelPartial()),
        A11yScreen("Custom action Pass", AccessibleCustomActionPass()),
        A11yScreen("Custom action Fail", AccessibleCustomActionFail()),
        A11yScreen("Custom action Partial", AccessibleCustomActionPartial()),
        A11yScreen("Touch event Pass", AccessibleTouchEventPass()),
        A11yScreen("Touch event Fail", AccessibleTouchEventFail()),
        A11yScreen("Touch event Partial", AccessibleTouchEventPartial()),

        // Batch 2 — error message announced, non-text contrast, focus obscured, modal dialogs,
        // tab controls and the screen title.
        A11yScreen("Error message Pass", AccessibleErrorMessagePass()),
        A11yScreen("Error message Fail", AccessibleErrorMessageFail()),
        A11yScreen("Error message Partial", AccessibleErrorMessagePartial()),

        A11yScreen("Non-text contrast Pass", AccessibleNonTextContrastPass()),
        A11yScreen("Non-text contrast Fail", AccessibleNonTextContrastFail()),
        A11yScreen("Non-text contrast Partial", AccessibleNonTextContrastPartial()),

        A11yScreen("Focus obscured Pass", AccessibleFocusObscuredPass()),
        A11yScreen("Focus obscured Fail", AccessibleFocusObscuredFail()),
        A11yScreen("Focus obscured Partial", AccessibleFocusObscuredPartial()),

        A11yScreen("Modal Pass", AccessibleModalPass()),
        A11yScreen("Modal Fail", AccessibleModalFail()),
        A11yScreen("Modal Partial", AccessibleModalPartial()),

        A11yScreen("Tab control Pass", AccessibleTabControlPass()),
        A11yScreen("Tab control Fail", AccessibleTabControlFail()),
        A11yScreen("Tab control Partial", AccessibleTabControlPartial()),

        A11yScreen("Screen title Pass", AccessibleScreenTitlePass()),
        A11yScreen("Screen title Fail", AccessibleScreenTitleFail()),
        A11yScreen("Screen title Partial", AccessibleScreenTitlePartial()),

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
