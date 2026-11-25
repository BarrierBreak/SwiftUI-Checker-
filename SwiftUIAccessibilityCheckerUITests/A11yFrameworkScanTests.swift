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

    // MARK: - Keyboard Link screens (BB41067) — a Fail-only rule

    func testAccessibleKeyboardLinkPass() throws {
        expectRows(try rowCounts("AccessibleKeyboardLinkPass", family: "keyboard"), [])
    }
    func testAccessibleKeyboardLinkFail() throws {
        expectRows(try rowCounts("AccessibleKeyboardLinkFail", family: "keyboard"),
                   [(Title.linkNotOperable, "Fail", 1)])
    }
    func testAccessibleKeyboardLinkPartial() throws {
        expectRows(try rowCounts("AccessibleKeyboardLinkPartial", family: "keyboard"),
                   [(Title.linkNotOperable, "Fail", 1)])
    }

    // MARK: - Keyboard Control screens (BB40066, was BB41036)

    func testAccessibleKeyboardControlPass() throws {
        expectRows(try rowCounts("AccessibleKeyboardControlPass", family: "keyboard"), [])
    }

    func testAccessibleKeyboardControlPartial() throws {
        expectRows(try rowCounts("AccessibleKeyboardControlPartial", family: "keyboard"),
                   [(Title.controlNoFocus, "Fail", 1)])
    }

    func testAccessibleKeyboardControlFail() throws {
        expectRows(try rowCounts("AccessibleKeyboardControlFail", family: "keyboard"),
                   [(Title.controlNoFocus, "Fail", 2)])
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
        static let errorFail = "Error message not announced by screen reader"
        static let controlFail = "Insufficient color contrast for non-text element"
        static let borderFail = "Insufficient color contrast for border of form controls"
        static let loadingFail = "Insufficient color contrast for loading indicator"
        static let obscuredValidate = "Check if focus indicator is obscured by another element"
        static let modalNoControls = "Modal has no keyboard-focusable interactive controls"
        static let modalNoEscape = "Modal dialog inaccessible for screen reader users"
        static let tabValidate = "Check if tab control needs to be hidden for screen reader user"
        static let titlePass = "Title is specified for screen"
        static let gestureKbPass = "Gesture-only control is operable with keyboard"
        static let gestureKbFail = "Gesture-only control not operable with keyboard"
        static let autocompletePass = "Autocomplete information is specified for form field"
        static let autocompleteFail = "Missing autocomplete information for form field"
        static let modalClosePass = "Modal dialog can be closed"
        static let languageChangeFail = "Change in language not defined correctly"
        static let focusOrderPass = "Screen has correct focus order"
        static let focusOrderValidate = "Check if focus order is correct on the screen"
        static let linkNotOperable = "Link not keyboard operable"
        static let controlNoFocus = "Interactive control cannot receive keyboard focus"
        static let orientationCheck = "Check if all the content is available when the device orientation is changed to landscape or portrait mode"
        static let orientationLocked = "Screen is locked in orientation"
        static let mapPass = "Map view has a text alternative"
        static let mapFail = "Missing textual description for map"
        static let adjustablePass = "Adjustable element exposes accessibilityValue"
        static let adjustableFail = "Adjustable element missing accessibilityValue"
        static let errorSuggestion = "Error message is accessible and includes a suggestion to fix it"
        static let modalScreenReaderPass = "Modal dialog is accessible for screen reader users"                       // BB40116
        static let modalKeyboardPass = "Modal contains keyboard-focusable controls — keyboard focus can be contained"  // BB40245
        static let loadingContrastPass = "Loading indicator has sufficient contrast with its background"              // BB40065
        static let liveRegionFail = "Live region not defined for dynamic content"                                      // BB40103
        static let liveRegionPass = "Live region is defined for dynamic content"                                       // BB40104
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

    // MARK: - Batch 2: error message, non-text contrast, focus obscured, modal, tab control, screen title

    func testAccessibleErrorMessagePass() throws {
        let c = try counts("AccessibleErrorMessagePass", family: "errorMessage")
        assertCount(c, Title.errorFail, 0)
    }

    func testAccessibleErrorMessageFail() throws {
        // Three errors are showing and all are hidden from VoiceOver, but the email error is
        // announced on submit, so only the password and phone errors are reported.
        let c = try counts("AccessibleErrorMessageFail", family: "errorMessage")
        assertCount(c, Title.errorFail, 2)
    }

    func testAccessibleErrorMessagePartial() throws {
        let c = try counts("AccessibleErrorMessagePartial", family: "errorMessage")
        assertCount(c, Title.errorFail, 1)
    }

    func testAccessibleNonTextContrastPass() throws {
        let c = try counts("AccessibleNonTextContrastPass", family: "nonTextContrast")
        assertCount(c, Title.borderFail, 0)
        assertCount(c, Title.loadingFail, 0)
        assertCount(c, Title.controlFail, 0)
    }

    func testAccessibleNonTextContrastFail() throws {
        let c = try counts("AccessibleNonTextContrastFail", family: "nonTextContrast")
        assertCount(c, Title.borderFail, 1)
        assertCount(c, Title.loadingFail, 1)
        assertCount(c, Title.controlFail, 2)
    }

    func testAccessibleNonTextContrastPartial() throws {
        let c = try counts("AccessibleNonTextContrastPartial", family: "nonTextContrast")
        assertCount(c, Title.borderFail, 1)
        assertCount(c, Title.loadingFail, 1)
        assertCount(c, Title.controlFail, 0)
    }

    func testAccessibleFocusObscuredPass() throws {
        let c = try counts("AccessibleFocusObscuredPass", family: "focusObscured")
        assertCount(c, Title.obscuredValidate, 0)
    }

    func testAccessibleFocusObscuredFail() throws {
        let c = try counts("AccessibleFocusObscuredFail", family: "focusObscured")
        assertCount(c, Title.obscuredValidate, 2)
    }

    func testAccessibleFocusObscuredPartial() throws {
        let c = try counts("AccessibleFocusObscuredPartial", family: "focusObscured")
        assertCount(c, Title.obscuredValidate, 1)
    }

    func testAccessibleModalPass() throws {
        let c = try counts("AccessibleModalPass", family: "modal")
        assertCount(c, Title.modalNoControls, 0)
        assertCount(c, Title.modalNoEscape, 0)
    }

    func testAccessibleModalFail() throws {
        let c = try counts("AccessibleModalFail", family: "modal")
        assertCount(c, Title.modalNoControls, 1)
        assertCount(c, Title.modalNoEscape, 2)
    }

    func testAccessibleModalPartial() throws {
        let c = try counts("AccessibleModalPartial", family: "modal")
        assertCount(c, Title.modalNoControls, 0)
        assertCount(c, Title.modalNoEscape, 1)
    }

    func testAccessibleTabControlPass() throws {
        let c = try counts("AccessibleTabControlPass", family: "tabControl")
        assertCount(c, Title.tabValidate, 0)
    }

    func testAccessibleTabControlFail() throws {
        let c = try counts("AccessibleTabControlFail", family: "tabControl")
        assertCount(c, Title.tabValidate, 2)
    }

    func testAccessibleTabControlPartial() throws {
        let c = try counts("AccessibleTabControlPartial", family: "tabControl")
        assertCount(c, Title.tabValidate, 1)
    }

    func testAccessibleScreenTitlePass() throws {
        let c = try counts("AccessibleScreenTitlePass", family: "screenTitle")
        assertCount(c, Title.titlePass, 1)
    }

    func testAccessibleScreenTitleFail() throws {
        let c = try counts("AccessibleScreenTitleFail", family: "screenTitle")
        assertCount(c, Title.titlePass, 0)
    }

    func testAccessibleScreenTitlePartial() throws {
        let c = try counts("AccessibleScreenTitlePartial", family: "screenTitle")
        assertCount(c, Title.titlePass, 1)
    }

    // MARK: - Batch 3: gesture keyboard, autocomplete, modal close, language change, focus order

    /// Scans `screen` and returns how many rows of each "title|status" the screen's own source produced
    /// (only this batch's rule titles are counted, like `counts`; other rules judge the same screens).
    private func rowCounts(_ screen: String, family: String) throws -> [String: Int] {
        let issues = try runScan(screen: screen, family: family, includePasses: true)
        var result: [String: Int] = [:]
        let ownTitles: Set<String> = [
            Title.gestureKbPass, Title.gestureKbFail, Title.autocompletePass, Title.autocompleteFail,
            Title.modalClosePass, Title.modalNoEscape, Title.languageChangeFail,
            Title.focusOrderPass, Title.focusOrderValidate, Title.linkNotOperable, Title.controlNoFocus,
            Title.orientationCheck, Title.orientationLocked,
            Title.mapPass, Title.mapFail, Title.adjustablePass, Title.adjustableFail, Title.errorSuggestion,
            Title.modalScreenReaderPass, Title.modalKeyboardPass, Title.loadingContrastPass,
            Title.liveRegionFail, Title.liveRegionPass, Title.modalNoControls, Title.loadingFail,
        ]
        // A source-linted finding names its file and line; a screen-level one (orientation) names
        // the hosting controller of the screen.
        for row in issues where (row.element.contains("\(screen).swift:") || row.class.contains("<\(screen)>"))
            && ownTitles.contains(row.rule) {
            result["\(row.rule)|\(row.status)", default: 0] += 1
        }
        return result
    }

    /// The scan's rows must be exactly `expected` (title, status, count) — nothing else.
    private func expectRows(_ c: [String: Int], _ expected: [(String, String, Int)],
                            file: StaticString = #filePath, line: UInt = #line) {
        var want: [String: Int] = [:]
        for (t, s, n) in expected { want["\(t)|\(s)"] = n }
        XCTAssertEqual(c, want, file: file, line: line)
    }

    // MARK: - Modal screen reader (BB40116), modal keyboard (BB40245), loading contrast (BB40065), live region (BB40103 / BB40104)
    // Each screen is scanned in the family of the rule it demonstrates; the failing side of the two modal
    // rules is read from family "modal".

    func testAccessibleModalScreenReaderPass() throws {
        expectRows(try rowCounts("AccessibleModalScreenReaderPass", family: "modalScreenReader"),
                   [(Title.modalScreenReaderPass, "Pass", 2)])
        expectRows(try rowCounts("AccessibleModalScreenReaderPass", family: "modal"), [])
    }
    func testAccessibleModalScreenReaderPartial() throws {
        expectRows(try rowCounts("AccessibleModalScreenReaderPartial", family: "modalScreenReader"),
                   [(Title.modalScreenReaderPass, "Pass", 1)])
        expectRows(try rowCounts("AccessibleModalScreenReaderPartial", family: "modal"),
                   [(Title.modalNoEscape, "Fail", 1)])
    }
    func testAccessibleModalScreenReaderFail() throws {
        expectRows(try rowCounts("AccessibleModalScreenReaderFail", family: "modalScreenReader"), [])
        expectRows(try rowCounts("AccessibleModalScreenReaderFail", family: "modal"),
                   [(Title.modalNoEscape, "Fail", 1)])
    }

    func testAccessibleModalKeyboardPass() throws {
        expectRows(try rowCounts("AccessibleModalKeyboardPass", family: "modalKeyboard"),
                   [(Title.modalKeyboardPass, "Pass", 1)])
        expectRows(try rowCounts("AccessibleModalKeyboardPass", family: "modal"), [])
    }
    func testAccessibleModalKeyboardPartial() throws {
        expectRows(try rowCounts("AccessibleModalKeyboardPartial", family: "modalKeyboard"),
                   [(Title.modalKeyboardPass, "Pass", 1)])
        expectRows(try rowCounts("AccessibleModalKeyboardPartial", family: "modal"),
                   [(Title.modalNoControls, "Fail", 1), (Title.modalNoEscape, "Fail", 1)])
    }
    func testAccessibleModalKeyboardFail() throws {
        expectRows(try rowCounts("AccessibleModalKeyboardFail", family: "modalKeyboard"), [])
        expectRows(try rowCounts("AccessibleModalKeyboardFail", family: "modal"),
                   [(Title.modalNoControls, "Fail", 1), (Title.modalNoEscape, "Fail", 1)])
    }

    func testAccessibleLoadingContrastPass() throws {
        expectRows(try rowCounts("AccessibleLoadingContrastPass", family: "nonTextContrast"),
                   [(Title.loadingContrastPass, "Pass", 2)])
    }
    func testAccessibleLoadingContrastPartial() throws {
        expectRows(try rowCounts("AccessibleLoadingContrastPartial", family: "nonTextContrast"),
                   [(Title.loadingContrastPass, "Pass", 1), (Title.loadingFail, "Fail", 1)])
    }
    func testAccessibleLoadingContrastFail() throws {
        expectRows(try rowCounts("AccessibleLoadingContrastFail", family: "nonTextContrast"),
                   [(Title.loadingFail, "Fail", 2)])
    }

    func testAccessibleLiveRegionPass() throws {
        expectRows(try rowCounts("AccessibleLiveRegionPass", family: "liveRegion"),
                   [(Title.liveRegionPass, "Pass", 2)])
    }
    func testAccessibleLiveRegionPartial() throws {
        expectRows(try rowCounts("AccessibleLiveRegionPartial", family: "liveRegion"),
                   [(Title.liveRegionPass, "Pass", 1), (Title.liveRegionFail, "Fail", 1)])
    }
    func testAccessibleLiveRegionFail() throws {
        expectRows(try rowCounts("AccessibleLiveRegionFail", family: "liveRegion"),
                   [(Title.liveRegionFail, "Fail", 2)])
    }

    // MARK: - Batch 4: map text alternative, adjustable value, error suggestion

    func testAccessibleMapPass() throws {
        expectRows(try rowCounts("AccessibleMapPass", family: "map"),
                   [(Title.mapPass, "Pass", 2)])
    }
    func testAccessibleMapFail() throws {
        expectRows(try rowCounts("AccessibleMapFail", family: "map"),
                   [(Title.mapFail, "Fail", 2)])
    }
    func testAccessibleMapPartial() throws {
        expectRows(try rowCounts("AccessibleMapPartial", family: "map"),
                   [(Title.mapPass, "Pass", 1), (Title.mapFail, "Fail", 1)])
    }

    func testAccessibleAdjustableValuePass() throws {
        expectRows(try rowCounts("AccessibleAdjustableValuePass", family: "adjustableValue"),
                   [(Title.adjustablePass, "Pass", 3)])
    }
    func testAccessibleAdjustableValueFail() throws {
        expectRows(try rowCounts("AccessibleAdjustableValueFail", family: "adjustableValue"),
                   [(Title.adjustableFail, "Fail", 2)])
    }
    func testAccessibleAdjustableValuePartial() throws {
        expectRows(try rowCounts("AccessibleAdjustableValuePartial", family: "adjustableValue"),
                   [(Title.adjustablePass, "Pass", 1), (Title.adjustableFail, "Fail", 1)])
    }

    func testAccessibleErrorSuggestionPass() throws {
        expectRows(try rowCounts("AccessibleErrorSuggestionPass", family: "errorSuggestion"),
                   [(Title.errorSuggestion, "Pass", 2)])
    }
    func testAccessibleErrorSuggestionFail() throws {
        // BB40097 is Pass-only: none of these errors both reaches VoiceOver and suggests a fix.
        expectRows(try rowCounts("AccessibleErrorSuggestionFail", family: "errorSuggestion"), [])
    }
    func testAccessibleErrorSuggestionPartial() throws {
        expectRows(try rowCounts("AccessibleErrorSuggestionPartial", family: "errorSuggestion"),
                   [(Title.errorSuggestion, "Pass", 1)])
    }

    func testAccessibleOrientationPass() throws {
        expectRows(try rowCounts("AccessibleOrientationPass", family: "orientation"),
                   [(Title.orientationCheck, "Validate", 1)])
    }
    func testAccessibleOrientationFail() throws {
        expectRows(try rowCounts("AccessibleOrientationFail", family: "orientation"),
                   [(Title.orientationLocked, "Fail", 1)])
    }
    func testAccessibleOrientationPartial() throws {
        expectRows(try rowCounts("AccessibleOrientationPartial", family: "orientation"),
                   [(Title.orientationLocked, "Fail", 1)])
    }

    func testAccessibleGestureKeyboardPass() throws {
        expectRows(try rowCounts("AccessibleGestureKeyboardPass", family: "gestureKeyboard"),
                   [(Title.gestureKbPass, "Pass", 2)])
    }
    func testAccessibleGestureKeyboardFail() throws {
        expectRows(try rowCounts("AccessibleGestureKeyboardFail", family: "gestureKeyboard"),
                   [(Title.gestureKbFail, "Fail", 2)])
    }
    func testAccessibleGestureKeyboardPartial() throws {
        expectRows(try rowCounts("AccessibleGestureKeyboardPartial", family: "gestureKeyboard"),
                   [(Title.gestureKbPass, "Pass", 1), (Title.gestureKbFail, "Fail", 1)])
    }

    func testAccessibleAutocompletePass() throws {
        expectRows(try rowCounts("AccessibleAutocompletePass", family: "autocomplete"),
                   [(Title.autocompletePass, "Pass", 2)])
    }
    func testAccessibleAutocompleteFail() throws {
        expectRows(try rowCounts("AccessibleAutocompleteFail", family: "autocomplete"),
                   [(Title.autocompleteFail, "Fail", 2)])
    }
    func testAccessibleAutocompletePartial() throws {
        expectRows(try rowCounts("AccessibleAutocompletePartial", family: "autocomplete"),
                   [(Title.autocompletePass, "Pass", 1), (Title.autocompleteFail, "Fail", 1)])
    }

    func testAccessibleModalClosePass() throws {
        expectRows(try rowCounts("AccessibleModalClosePass", family: "modalClose"),
                   [(Title.modalClosePass, "Pass", 1)])
        expectRows(try rowCounts("AccessibleModalClosePass", family: "modal"), [])
    }
    func testAccessibleModalCloseFail() throws {
        expectRows(try rowCounts("AccessibleModalCloseFail", family: "modalClose"), [])
        expectRows(try rowCounts("AccessibleModalCloseFail", family: "modal"),
                   [(Title.modalNoEscape, "Fail", 1)])
    }
    func testAccessibleModalClosePartial() throws {
        expectRows(try rowCounts("AccessibleModalClosePartial", family: "modalClose"),
                   [(Title.modalClosePass, "Pass", 1)])
        expectRows(try rowCounts("AccessibleModalClosePartial", family: "modal"),
                   [(Title.modalNoEscape, "Fail", 1)])
    }

    func testAccessibleLanguageChangePass() throws {
        expectRows(try rowCounts("AccessibleLanguageChangePass", family: "languageChange"), [])
    }
    func testAccessibleLanguageChangeFail() throws {
        expectRows(try rowCounts("AccessibleLanguageChangeFail", family: "languageChange"),
                   [(Title.languageChangeFail, "Fail", 2)])
    }
    func testAccessibleLanguageChangePartial() throws {
        expectRows(try rowCounts("AccessibleLanguageChangePartial", family: "languageChange"),
                   [(Title.languageChangeFail, "Fail", 1)])
    }

    func testAccessibleFocusOrderPass() throws {
        expectRows(try rowCounts("AccessibleFocusOrderPass", family: "focusOrder"),
                   [(Title.focusOrderPass, "Pass", 1)])
    }
    func testAccessibleFocusOrderFail() throws {
        expectRows(try rowCounts("AccessibleFocusOrderFail", family: "focusOrder"),
                   [(Title.focusOrderValidate, "Validate", 1)])
    }
    func testAccessibleFocusOrderRedirectFail() throws {
        expectRows(try rowCounts("AccessibleFocusOrderRedirectFail", family: "focusOrder"),
                   [(Title.focusOrderValidate, "Validate", 2)])
    }
    func testAccessibleFocusOrderPartial() throws {
        expectRows(try rowCounts("AccessibleFocusOrderPartial", family: "focusOrder"),
                   [(Title.focusOrderPass, "Pass", 1), (Title.focusOrderValidate, "Validate", 1)])
    }

    /// Every screen in one run — the combined report, as before.
    func testAllScreens() throws {
        try runScan(screen: nil)
    }
}
