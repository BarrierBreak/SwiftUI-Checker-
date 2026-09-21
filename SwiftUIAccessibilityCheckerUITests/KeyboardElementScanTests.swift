//
//  KeyboardElementScanTests.swift
//  SwiftUIAccessibilityCheckerUITests
//
//  Scan coverage for AccessibleKeyboard{Pass,Fail,Partial}, against the framework's six
//  keyboard rules (KeyboardFocusableWorkflow):
//
//    BB41035  Button not operable with keyboard
//    BB41067  Link not keyboard operable
//    BB41036  Interactive control cannot receive keyboard focus
//    BB41037  Interactive control not operable with keyboard
//    BB41005  Non-interactive element receives keyboard focus
//    BB41015  Hidden content receives keyboard focus
//
//  WHAT SWIFTUI CAN AND CANNOT BE SCANNED FOR TODAY
//
//  Four of the six read `UIView.canBecomeFocused` and the presence of a target-action or
//  accessibility custom action off a live backing view. A SwiftUI screen does not give the
//  scan one backing UIView per control — the controls exist only in the accessibility tree,
//  and `SwiftUIAccessibilityElement` carries a label, value, hint, traits and a frame, but
//  no focus state and no action information. There is therefore nothing to read: a correct
//  SwiftUI `Button` and `AccessibleKeyboardFail`'s deliberately-unfocusable chip expose the
//  identical `.button` trait and are indistinguishable at runtime.
//
//  BB41015 is the exception and does work here, because it asks about geometry, which the
//  accessibility tree does carry.
//
//  `testSwiftUIKeyboardDetectionGapIsStillOpen` pins that gap on purpose, in the same style
//  this repo already uses elsewhere: when SwiftUI keyboard detection lands — the route is a
//  source-level check in Scripts/source_role_linter.py, which is how the other SwiftUI-only
//  shapes such as LINK_WITHOUT_ROLE are already caught — that test fails, and turning it into
//  real per-element expectations becomes a deliberate, visible change.
//
import XCTest

final class KeyboardElementScanTests: XCTestCase {

    private let buttonInoperable = "Button not operable with keyboard"
    private let linkInoperable = "Link not keyboard operable"
    private let controlUnreachable = "Interactive control cannot receive keyboard focus"
    private let controlInoperable = "Interactive control not operable with keyboard"
    private let nonInteractiveFocusable = "Non-interactive element receives keyboard focus"
    private let hiddenFocusable = "Hidden content receives keyboard focus"

    /// The four rules that name a control a keyboard user cannot reach or cannot operate.
    private var reachabilityRules: [String] {
        [buttonInoperable, linkInoperable, controlUnreachable, controlInoperable]
    }

    private var allKeyboardRules: [String] {
        reachabilityRules + [nonInteractiveFocusable, hiddenFocusable]
    }

    /// Titles from the retired BB60046-49 set and from the deleted KeyboardNavigationWorkflow.
    /// Their database rows are gone, so a scan that still prints one means the app is linked
    /// against a stale framework binary rather than a rebuilt one.
    private let retiredRules = [
        "Interactive control can receive keyboard focus",
        "Focusable control may not respond to a keyboard Select press",
        "SwiftUI control's keyboard-focus reachability cannot be verified automatically",
        "Interactive view uses gesture-only interaction with no accessibility alternative",
        "Interactive view has an accessibility alternative for gesture interaction",
    ]

    private let screens = [
        "AccessibleKeyboardPass",
        "AccessibleKeyboardFail",
        "AccessibleKeyboardPartial",
    ]

    // MARK: - Registration

    /// Each screen has to be listed in `SwiftUIA11yScan.screens` for `--a11y-screen=<ViewName>`
    /// to find it. A screen added to the project but never registered scans nothing and fails
    /// here.
    func testKeyboardScreens_scanAndReportFindings() throws {
        for screen in screens {
            let issues = try runScan(screen: screen)
            XCTAssertFalse(
                issues.isEmpty,
                "\(screen) produced no findings at all — check it is registered in SwiftUIA11yScan.screens"
            )
        }
    }

    // MARK: - No false positives

    /// `AccessibleKeyboardPass` builds its chips out of real SwiftUI controls with
    /// `.focusable()`, so no keyboard rule may name anything on it.
    func testPassScreen_hasNoKeyboardFinding() throws {
        let offenders = try runScan(screen: "AccessibleKeyboardPass")
            .filter { allKeyboardRules.contains($0.rule) }
            .map { "[\($0.rule)] \($0.class) — \($0.element)" }

        XCTAssertTrue(
            offenders.isEmpty,
            "AccessibleKeyboardPass is a reference screen — no keyboard rule should name anything on it. Reported: \(offenders)"
        )
    }

    /// The stale-binary guard. If the app is still linked against a framework built before
    /// the BB60046-49 rows were deleted, these titles come back — and every other assertion
    /// in this file would be testing the wrong binary.
    func testRetiredKeyboardRulesNeverReappear() throws {
        for screen in screens {
            for issue in try runScan(screen: screen, includePasses: true) {
                XCTAssertFalse(
                    retiredRules.contains(issue.rule),
                    "\(screen) reported retired keyboard rule '\(issue.rule)' — the linked framework binary is stale"
                )
            }
        }
    }

    /// Any row that reads as a keyboard rule has to be one of the six. Catches a rule being
    /// reworded in the database without this file being updated to match.
    func testOnlyTheSixKeyboardRulesAreReported() throws {
        for screen in screens {
            for issue in try runScan(screen: screen, includePasses: true) {
                guard issue.rule.lowercased().contains("keyboard focus")
                        || issue.rule.lowercased().contains("operable with keyboard")
                        || issue.rule.lowercased().contains("keyboard operable") else { continue }
                XCTAssertTrue(
                    allKeyboardRules.contains(issue.rule),
                    "\(screen) reported an unexpected keyboard rule: '\(issue.rule)'"
                )
            }
        }
    }

    // MARK: - The open gap

    /// `AccessibleKeyboardFail`'s `KeyboardInaccessibleChip` is a `Text` with `.onTapGesture`
    /// and `.accessibilityAddTraits(.isButton)` and no `.focusable()` — a button a hardware
    /// keyboard cannot reach. Its UIKit twin in the sibling app reports
    /// "Button not operable with keyboard"; here nothing reports it, because the runtime scan
    /// has no backing view to read a focus state from.
    ///
    /// This test fails the moment that changes, which is the point: replace it with real
    /// per-element assertions at that time.
    func testSwiftUIKeyboardDetectionGapIsStillOpen() throws {
        var seen: [String] = []
        for screen in ["AccessibleKeyboardFail", "AccessibleKeyboardPartial"] {
            seen += try runScan(screen: screen)
                .filter { reachabilityRules.contains($0.rule) }
                .map { "\(screen): [\($0.rule)] \($0.class) — \($0.element)" }
        }

        XCTAssertTrue(
            seen.isEmpty,
            """
            A keyboard reachability rule now reports on a SwiftUI screen. That is an \
            improvement, not a regression — replace this test with real per-element \
            assertions for: \(seen)
            """
        )
    }
}
