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

    // MARK: - Color Contrast screens

    func testAccessibleColorContrastPass() throws {
        try runScan(screen: "AccessibleColorContrastPass")
    }

    func testAccessibleColorContrastFail() throws {
        try runScan(screen: "AccessibleColorContrastFail")
    }

    func testAccessibleColorContrastPartial() throws {
        try runScan(screen: "AccessibleColorContrastPartial")
    }

    /// Every screen in one run — the combined report, as before.
    func testAllScreens() throws {
        try runScan(screen: nil)
    }
}
