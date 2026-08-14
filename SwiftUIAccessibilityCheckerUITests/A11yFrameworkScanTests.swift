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

    /// Every screen in one run — the combined report, as before.
    func testAllScreens() throws {
        try runScan(screen: nil)
    }

    // MARK: - Shared scan

    /// Launches the app, scans `screen` (or all screens when nil), and attaches the report.
    private func runScan(screen: String?, file: StaticString = #filePath, line: UInt = #line) throws {
        let app = XCUIApplication()
        app.launchArguments = ["--a11y-scan"]
        if let screen {
            app.launchArguments.append("--a11y-screen=\(screen)")
        }
        app.launch()

        // Wait for the app to signal it finished scanning. The app adds a hidden label
        // with this identifier when writeSummary() completes.
        let scanDoneSignal = app.staticTexts["a11yScanDone"]
        guard scanDoneSignal.waitForExistence(timeout: 60) else {
            XCTFail("Scan did not complete within the timeout — check Xcode console for [A11yDemo] errors.",
                    file: file, line: line)
            return
        }

        // The report text is stored in the signal element's accessibilityValue.
        // This avoids UIPasteboard which is blocked in UITest runners on device.
        guard let reportText = scanDoneSignal.value as? String, !reportText.isEmpty else {
            XCTFail("Report was empty — check Xcode console for [A11yDemo] errors.",
                    file: file, line: line)
            return
        }

        let attachment = XCTAttachment(string: reportText)
        attachment.name = screen.map { "A11y Scan Report — \($0)" } ?? "A11y Demo Scan Report"
        attachment.lifetime = .keepAlways
        add(attachment)

        print("\n\(reportText)\n")
    }
}
