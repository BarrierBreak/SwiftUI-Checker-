//
//  A11yFrameworkScanTests.swift
//  SwiftUIAccessibilityCheckerUITests
//
//  One test function per example screen, each named after that screen's View type, so a
//  single screen can be scanned on its own — put the caret in the function and press
//  ⌃⌘U, or click the diamond next to it in the Test navigator. Running the whole class
//  runs each screen as its own test, plus testAllScreens() for the combined report.
//
//  Each function launches the app with --a11y-scan and --a11y-screen=<ClassName>, waits
//  for the framework to finish, then attaches the report to the test result (Report
//  Navigator → the test → "A11y Demo Scan Report"). The report is also written to
//  ~/Documents/a11y-demo-report.txt in the simulator container.
//
//  XCTest only discovers methods whose name begins with "test", so each function is the
//  screen's type name with that prefix.
//

import XCTest

final class A11yDemoScanTests: XCTestCase {

    // MARK: - One function per screen

    func testAccessibleNamePass() throws {
        try runScan(screen: "AccessibleNamePass")
    }

    func testAccessibleNameFail() throws {
        try runScan(screen: "AccessibleNameFail")
    }

    func testAccessibleNamePartial() throws {
        try runScan(screen: "AccessibleNamePartial")
    }

    func testAccessibleNameExtrasPass() throws {
        try runScan(screen: "AccessibleNameExtrasPass")
    }

    func testAccessibleNameExtrasFail() throws {
        try runScan(screen: "AccessibleNameExtrasFail")
    }

    func testAccessibleNameExtrasPartial() throws {
        try runScan(screen: "AccessibleNameExtrasPartial")
    }

    // MARK: - Role screens

    func testAccessibleNativeRolePass() throws {
        try runScan(screen: "AccessibleNativeRolePass")
    }

    func testAccessibleNativeRoleFail() throws {
        try runScan(screen: "AccessibleNativeRoleFail")
    }

    func testAccessibleNativeRolePartial() throws {
        try runScan(screen: "AccessibleNativeRolePartial")
    }

    func testAccessibleRolePass() throws {
        try runScan(screen: "AccessibleRolePass")
    }

    func testAccessibleRoleFail() throws {
        try runScan(screen: "AccessibleRoleFail")
    }

    func testAccessibleRolePartial() throws {
        try runScan(screen: "AccessibleRolePartial")
    }

    // MARK: - State screens

    func testAccessibleStatePass() throws {
        try runScan(screen: "AccessibleStatePass")
    }

    func testAccessibleStateFail() throws {
        try runScan(screen: "AccessibleStateFail")
    }

    func testAccessibleStatePartial() throws {
        try runScan(screen: "AccessibleStatePartial")
    }

    // MARK: - Keyboard screens

    func testAccessibleKeyboardPass() throws {
        try runScan(screen: "AccessibleKeyboardPass")
    }

    func testAccessibleKeyboardFail() throws {
        try runScan(screen: "AccessibleKeyboardFail")
    }

    func testAccessibleKeyboardPartial() throws {
        try runScan(screen: "AccessibleKeyboardPartial")
    }

    // MARK: - Target Size screens

    func testAccessibleTargetSizePass() throws {
        try runScan(screen: "AccessibleTargetSizePass")
    }

    func testAccessibleTargetSizeFail() throws {
        try runScan(screen: "AccessibleTargetSizeFail")
    }

    func testAccessibleTargetSizePartial() throws {
        try runScan(screen: "AccessibleTargetSizePartial")
    }

    // MARK: - Color Contrast screens

    func testAccessibleTextContrastPass() throws {
        try runScan(screen: "AccessibleTextContrastPass")
    }

    func testAccessibleTextContrastFail() throws {
        try runScan(screen: "AccessibleTextContrastFail")
    }

    func testAccessibleTextContrastPartial() throws {
        try runScan(screen: "AccessibleTextContrastPartial")
    }

    func testAccessibleTextContrastCompositedPass() throws {
        try runScan(screen: "AccessibleTextContrastCompositedPass")
    }

    func testAccessibleTextContrastCompositedFail() throws {
        try runScan(screen: "AccessibleTextContrastCompositedFail")
    }

    func testAccessibleTextContrastCompositedPartial() throws {
        try runScan(screen: "AccessibleTextContrastCompositedPartial")
    }

    // MARK: - Focus screens

    func testAccessibleFocusPass() throws {
        try runScan(screen: "AccessibleFocusPass")
    }

    func testAccessibleFocusFail() throws {
        try runScan(screen: "AccessibleFocusFail")
    }

    func testAccessibleFocusPartial() throws {
        try runScan(screen: "AccessibleFocusPartial")
    }

    // MARK: - Link screens

    func testAccessibleLinkPass() throws {
        try runScan(screen: "AccessibleLinkPass")
    }

    func testAccessibleLinkFail() throws {
        try runScan(screen: "AccessibleLinkFail")
    }

    func testAccessibleLinkPartial() throws {
        try runScan(screen: "AccessibleLinkPartial")
    }

    // MARK: - Reading Order screens

    func testAccessibleReadingOrderPass() throws {
        try runScan(screen: "AccessibleReadingOrderPass")
    }

    func testAccessibleReadingOrderFail() throws {
        try runScan(screen: "AccessibleReadingOrderFail")
    }

    func testAccessibleReadingOrderPartial() throws {
        try runScan(screen: "AccessibleReadingOrderPartial")
    }

    // MARK: - Image screens

    func testAccessibleImagesPass() throws {
        try runScan(screen: "AccessibleImagesPass")
    }

    func testAccessibleImagesFail() throws {
        try runScan(screen: "AccessibleImagesFail")
    }

    func testAccessibleImagesPartial() throws {
        try runScan(screen: "AccessibleImagesPartial")
    }

    // MARK: - Motion screens

    func testAccessibleMotionPass() throws {
        try runScan(screen: "AccessibleMotionPass")
    }

    func testAccessibleMotionFail() throws {
        try runScan(screen: "AccessibleMotionFail")
    }

    func testAccessibleMotionPartial() throws {
        try runScan(screen: "AccessibleMotionPartial")
    }

    // MARK: - Language screens

    func testAccessibleLanguagePass() throws {
        try runScan(screen: "AccessibleLanguagePass")
    }

    func testAccessibleLanguageFail() throws {
        try runScan(screen: "AccessibleLanguageFail")
    }

    func testAccessibleLanguagePartial() throws {
        try runScan(screen: "AccessibleLanguagePartial")
    }

    // MARK: - Hidden from Screen Reader screens

    func testAccessibleHiddenPass() throws {
        try runScan(screen: "AccessibleHiddenPass")
    }

    func testAccessibleHiddenFail() throws {
        try runScan(screen: "AccessibleHiddenFail")
    }

    func testAccessibleHiddenPartial() throws {
        try runScan(screen: "AccessibleHiddenPartial")
    }

    // MARK: - Role trait screens

    // MARK: - State trait screens

    // MARK: - Form label screens

    // MARK: - Custom action screens

    // MARK: - Touch event screens


    // MARK: - New rules: role trait, state trait, button, form label, custom action, touch event
    //
    // These scan their screen and assert the rows its doc comment promises (only the eleven
    // rules' own titles are counted; other families judge the same screens).


    private enum Title {
        static let roleFail = "Accessibility role trait does not match element type"
        static let rolePass = "Accessibility role trait correctly matches element type"
        static let statePass = "Accessibility state trait correctly reflects element's actual state"
        static let buttonValidate = "Verify if button does not require interaction"
        static let formFail = "Placeholder text used as the only accessible name — no visible label present"
        static let gestureFail = "Complex gesture has no accessibility alternative"
        static let gesturePass = "Custom action present for gesture"
        static let downFail = "Action fires on touch down instead of touch up"
        static let upPass = "Action fires on touch up, allowing cancellation"
    }

    /// Scans `screen` and returns how many rows of each title the screen's own source produced.
    private func counts(_ screen: String, family: String) throws -> [String: Int] {
        let issues = try runScan(screen: screen, family: family, includePasses: true)
        var result: [String: Int] = [:]
        for row in issues where row.element.contains("\(screen).swift:") {
            result[row.rule, default: 0] += 1
        }
        return result
    }

    private func assertCount(_ counts: [String: Int], _ title: String, _ expected: Int,
                             file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(counts[title] ?? 0, expected, "\"\(title)\"\nall: \(counts)", file: file, line: line)
    }

    // MARK: - Role trait

    func testAccessibleRoleTraitPass() throws {
        let c = try counts("AccessibleRoleTraitPass", family: "roleTrait")
        assertCount(c, Title.rolePass, 5)
        assertCount(c, Title.roleFail, 0)
    }

    func testAccessibleRoleTraitFail() throws {
        let c = try counts("AccessibleRoleTraitFail", family: "roleTrait")
        assertCount(c, Title.roleFail, 5)
        assertCount(c, Title.rolePass, 0)
    }

    func testAccessibleRoleTraitPartial() throws {
        let c = try counts("AccessibleRoleTraitPartial", family: "roleTrait")
        assertCount(c, Title.rolePass, 2)
        assertCount(c, Title.roleFail, 2)
    }

    // MARK: - State trait

    func testAccessibleStateTraitPass() throws {
        assertCount(try counts("AccessibleStateTraitPass", family: "stateTrait"), Title.statePass, 3)
    }

    func testAccessibleStateTraitFail() throws {
        assertCount(try counts("AccessibleStateTraitFail", family: "stateTrait"), Title.statePass, 0)
    }

    func testAccessibleStateTraitPartial() throws {
        assertCount(try counts("AccessibleStateTraitPartial", family: "stateTrait"), Title.statePass, 1)
    }

    // MARK: - Button

    func testAccessibleButtonPass() throws {
        assertCount(try counts("AccessibleButtonPass", family: "button"), Title.buttonValidate, 0)
    }

    func testAccessibleButtonFail() throws {
        assertCount(try counts("AccessibleButtonFail", family: "button"), Title.buttonValidate, 3)
    }

    func testAccessibleButtonPartial() throws {
        assertCount(try counts("AccessibleButtonPartial", family: "button"), Title.buttonValidate, 1)
    }

    // MARK: - Form label

    func testAccessibleFormLabelPass() throws {
        assertCount(try counts("AccessibleFormLabelPass", family: "formLabel"), Title.formFail, 0)
    }

    func testAccessibleFormLabelFail() throws {
        assertCount(try counts("AccessibleFormLabelFail", family: "formLabel"), Title.formFail, 3)
    }

    func testAccessibleFormLabelPartial() throws {
        assertCount(try counts("AccessibleFormLabelPartial", family: "formLabel"), Title.formFail, 1)
    }

    // MARK: - Custom action

    func testAccessibleCustomActionPass() throws {
        let c = try counts("AccessibleCustomActionPass", family: "customAction")
        assertCount(c, Title.gesturePass, 3)
        assertCount(c, Title.gestureFail, 0)
    }

    func testAccessibleCustomActionFail() throws {
        let c = try counts("AccessibleCustomActionFail", family: "customAction")
        assertCount(c, Title.gestureFail, 3)
        assertCount(c, Title.gesturePass, 0)
    }

    func testAccessibleCustomActionPartial() throws {
        let c = try counts("AccessibleCustomActionPartial", family: "customAction")
        assertCount(c, Title.gesturePass, 1)
        assertCount(c, Title.gestureFail, 1)
    }

    // MARK: - Touch event

    func testAccessibleTouchEventPass() throws {
        let c = try counts("AccessibleTouchEventPass", family: "pointerCancellation")
        assertCount(c, Title.upPass, 2)
        assertCount(c, Title.downFail, 0)
    }

    func testAccessibleTouchEventFail() throws {
        let c = try counts("AccessibleTouchEventFail", family: "pointerCancellation")
        assertCount(c, Title.downFail, 2)
        assertCount(c, Title.upPass, 0)
    }

    func testAccessibleTouchEventPartial() throws {
        let c = try counts("AccessibleTouchEventPartial", family: "pointerCancellation")
        assertCount(c, Title.upPass, 1)
        assertCount(c, Title.downFail, 1)
    }

    /// Every screen in one run — the combined report, as before.
    func testAllScreens() throws {
        try runScan(screen: nil)
    }
}
