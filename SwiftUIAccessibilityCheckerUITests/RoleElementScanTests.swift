//
//  RoleElementScanTests.swift
//  SwiftUIAccessibilityCheckerUITests
//
//  Element-level regression coverage for the two "Role" example screen families
//  (AccessibleRolePass/Fail/Partial and AccessibleNativeRolePass/Fail/Partial), which
//  together demonstrate accessibility ROLE bugs (as opposed to the NAME bugs the
//  AccessibleName* screens cover): button, header, link, filter-chip/checkbox, radio
//  row, adjustable dial, decorative icon, plus the native-vs-hand-built-clone pairing
//  for Toggle, Slider, Stepper, Segmented Picker, and Checkbox-style Toggle.
//
//  Unlike A11yFrameworkScanTests (which only checks that a scan completes), these
//  assert the SPECIFIC rule/element pairing the framework must report for each control
//  on each tier — real regression protection for the report-assembly pipeline and for
//  the tap-without-role classification below.
//
//  A tap-without-role finding now splits three ways instead of always reading
//  "Missing role for button":
//    - the tapped element IS an image AND its handler does something real  → BB41004
//      "Missing role for button" (an icon a user can double-tap behaves like a button
//      either way, so that's a fair, specific diagnosis)
//    - the tapped element IS an image but the handler is a comment-only placeholder
//      (this codebase's convention for "not implemented yet") → not reported at all;
//      a decorative icon with a no-op tap isn't a real defect
//    - anything else (text, a custom shape, a container) → BB60038 "Missing role for
//      interactive control" — "button" is a guess the linter has no basis for outside
//      the image case, so this reports only that SOME role is missing
//
//  Grouping (BB60037, "not grouped into a single accessible control") and the
//  screen-level "Headings not defined" (BB41008) were both removed; BB40041 ("this
//  text reads like a heading") remains as the sole heading-role signal and always runs.
//

import XCTest

final class RoleElementScanTests: XCTestCase {

    // MARK: - AccessibleRolePass — every control has the correct role; nothing should Fail

    func testAccessibleRolePass_noFailures() throws {
        let issues = try runScan(screen: "AccessibleRolePass")
        let fails = issues.filter { $0.status.lowercased() == "fail" }
        XCTAssertTrue(fails.isEmpty, "Role Pass should have zero Fail rows, got: \(fails.map(\.rule))")
    }

    // MARK: - AccessibleRoleFail — custom button, link, filter chip, radio rows

    func testAccessibleRoleFail_customButton_wrongRole() throws {
        let issues = try runScan(screen: "AccessibleRoleFail")
        // Text("Refresh") is explicitly marked .isStaticText despite a real tap handler —
        // an active mis-assignment (a role IS present, just the wrong one), not an absent
        // role, so this is "Wrong role", not "Missing role". It should also no longer be
        // suggested as a heading candidate now that its real defect is identified.
        assertFires(issues, rule: "Wrong role for interactive control", elementContaining: "Refresh")
        assertDoesNotFire(issues, rule: "Missing role for interactive control", elementContaining: "Refresh")
        assertDoesNotFire(issues, rule: "Check whether the text should be a heading", elementContaining: "Refresh")
    }

    func testAccessibleRoleFail_customLink_wrongRole() throws {
        let issues = try runScan(screen: "AccessibleRoleFail")
        assertFires(issues, rule: "Text functions as a link but is missing role link", elementContaining: "View documentation")
    }

    func testAccessibleRoleFail_filterChip_missingRoleSplitsByElementType() throws {
        let issues = try runScan(screen: "AccessibleRoleFail")
        // The chip is an icon + a label sharing one source line, with no trait at all on
        // either — the icon (an SF Symbol, so its own accessibility label is "Square") is a
        // real image with a real toggle action, so it gets the specific button-role finding;
        // the text sibling gets the generic interactive-control finding.
        assertFires(issues, rule: "Missing role for button", elementContaining: "Square")
        assertFires(issues, rule: "Missing role for interactive control", elementContaining: "Wi-Fi Only")
    }

    func testAccessibleRoleFail_radioRow_missingRoleSplitsByElementType() throws {
        let issues = try runScan(screen: "AccessibleRoleFail")
        // Same split as the filter chip: the row's checkmark icon (labeled "Selected") is an
        // image with a real action → button-specific finding; the row's text → generic.
        assertFires(issues, rule: "Missing role for button", elementContaining: "Selected")
        assertFires(issues, rule: "Missing role for interactive control", elementContaining: "Standard (5-7 days)")
    }

    func testAccessibleRoleFail_adjustableDial_wrongRole() throws {
        let issues = try runScan(screen: "AccessibleRoleFail")
        // The Brightness dial responds to a DragGesture (a continuous value) but is
        // marked .isButton (a discrete action) with no .accessibilityAdjustableAction —
        // an actively wrong role, not merely a missing one.
        assertFires(issues, rule: "Wrong role for interactive control", elementContaining: "Brightness")
        // The old "verify the button's name is descriptive" check is misleading once the
        // control isn't even correctly a button — it should be suppressed for this line.
        assertDoesNotFire(issues, rule: "Verify if accessible name for button is descriptive", elementContaining: "Brightness")
    }

    func testAccessibleRoleFail_noGroupingOrScreenLevelHeadingFindings() throws {
        let issues = try runScan(screen: "AccessibleRoleFail")
        // Both removed features — pins down that they stay gone.
        XCTAssertTrue(issues.filter { $0.rule.contains("grouped into a single accessible control") }.isEmpty,
                      "Grouping should no longer be reported")
        XCTAssertTrue(issues.filter { $0.rule == "Headings not defined" }.isEmpty,
                      "Screen-level 'Headings not defined' should no longer be reported")
    }

    // MARK: - AccessibleRolePartial — role omitted (not wrong), still a Fail where it's the
    // only signal available; state-only defects (missing .isSelected, missing adjustable
    // action) are known gaps this framework does not yet detect — not asserted here.

    func testAccessibleRolePartial_customButton_missingRole() throws {
        let issues = try runScan(screen: "AccessibleRolePartial")
        assertFires(issues, rule: "Missing role for interactive control", elementContaining: "Refresh")
    }

    func testAccessibleRolePartial_customLink_missingRole() throws {
        let issues = try runScan(screen: "AccessibleRolePartial")
        assertFires(issues, rule: "Missing role for interactive control", elementContaining: "View documentation")
    }

    func testAccessibleRolePartial_decorativeIcon_placeholderTapNotFlagged() throws {
        let issues = try runScan(screen: "AccessibleRolePartial")
        // sparkle's tap handler here is a comment-only placeholder ("/* hidden easter egg */"),
        // and it IS an image — the image branch only reports when the action is real, so this
        // decorative icon should not be flagged under either role-missing rule.
        assertDoesNotFire(issues, rule: "Missing role for button", elementContaining: "sparkle")
        assertDoesNotFire(issues, rule: "Missing role for interactive control", elementContaining: "sparkle")
    }

    func testAccessibleRolePartial_adjustableDial_missingRoleIsGeneric() throws {
        let issues = try runScan(screen: "AccessibleRolePartial")
        // No trait at all here (unlike Fail's wrongly-.isButton dial) — so this is a
        // plain missing role, not an actively wrong one; it should get the generic
        // finding, not the "wrong role" one that claims a discrete trait was assigned.
        assertFires(issues, rule: "Missing role for interactive control", elementContaining: "Brightness")
        assertDoesNotFire(issues, rule: "Wrong role for interactive control", elementContaining: "Brightness")
    }

    func testAccessibleRolePartial_filterChipAndRadioRow_alreadyHaveButtonRole() throws {
        let issues = try runScan(screen: "AccessibleRolePartial")
        // Partial gives these .isButton already (only .isSelected is missing, which nothing
        // detects yet) — so neither should report any missing-role finding.
        for rule in ["Missing role for button", "Missing role for interactive control"] {
            assertDoesNotFire(issues, rule: rule, elementContaining: "Wi-Fi Only")
            assertDoesNotFire(issues, rule: rule, elementContaining: "Standard (5-7 days)")
        }
    }

    // MARK: - AccessibleNativeRolePass — native controls; nothing should Fail

    func testAccessibleNativeRolePass_noFailures() throws {
        let issues = try runScan(screen: "AccessibleNativeRolePass")
        let fails = issues.filter { $0.status.lowercased() == "fail" }
        XCTAssertTrue(fails.isEmpty, "Native Role Pass should have zero Fail rows, got: \(fails.map(\.rule))")
    }

    // MARK: - AccessibleNativeRoleFail — hand-drawn clones with zero accessibility wiring

    func testAccessibleNativeRoleFail_customSwitchAndSlider_missingName() throws {
        let issues = try runScan(screen: "AccessibleNativeRoleFail")
        // Neither the hand-drawn switch (line 35) nor the hand-drawn slider (line 59) has an
        // accessibilityLabel, so both report as "no name" — the JSON summary has no source
        // line to tell them apart by, so this checks the count rather than which is which.
        let missingName = issues.filter {
            $0.rule == "Missing accessible name for interactive control"
                && $0.status.lowercased() == "fail"
                && $0.element == "no name"
        }
        XCTAssertEqual(missingName.count, 2, "Expected both the custom switch and custom slider to report a missing name, got: \(missingName.count)")
    }

    func testAccessibleNativeRoleFail_customSwitch_missingRoleIsGeneric() throws {
        let issues = try runScan(screen: "AccessibleNativeRoleFail")
        // Only the switch is tap-driven (the slider uses a DragGesture, which the
        // tap-without-role check does not look at). It's a hand-drawn Capsule+Circle, not an
        // image, so the missing role is the generic finding, not the button-specific one —
        // there is no reliable way to recognize "this shape was meant to be a switch" from
        // traits alone, so it falls into the same generic bucket as any other custom shape.
        assertFires(issues, rule: "Missing role for interactive control", elementContaining: "no name")
        assertDoesNotFire(issues, rule: "Missing role for button", elementContaining: "no name")
    }

    func testAccessibleNativeRoleFail_customCheckbox_missingRoleSplitsByElementType() throws {
        let issues = try runScan(screen: "AccessibleNativeRoleFail")
        // Same icon/text split as AccessibleRoleFail's filter chip: the checkbox image (SF
        // Symbol → labeled "Square") gets the button-specific finding; the agreement text
        // sharing its source line gets the generic one.
        assertFires(issues, rule: "Missing role for button", elementContaining: "Square")
        assertFires(issues, rule: "Missing role for interactive control", elementContaining: "I agree to the Terms of Service")
    }

    func testAccessibleNativeRoleFail_noGroupingOrScreenLevelHeadingFindings() throws {
        let issues = try runScan(screen: "AccessibleNativeRoleFail")
        XCTAssertTrue(issues.filter { $0.rule.contains("grouped into a single accessible control") }.isEmpty,
                      "Grouping should no longer be reported")
        XCTAssertTrue(issues.filter { $0.rule == "Headings not defined" }.isEmpty,
                      "Screen-level 'Headings not defined' should no longer be reported")
    }

    // MARK: - AccessibleNativeRolePartial — buttons/labels present, only live-state wiring
    // missing (hardcoded value, no adjustable action, no isSelected, no accessibilityValue).
    // None of these state-only defects are detected yet, so this tier should have no Fails —
    // this pins down that known gap so a future fix is a deliberate, visible change here.

    func testAccessibleNativeRolePartial_noFailures() throws {
        let issues = try runScan(screen: "AccessibleNativeRolePartial")
        let fails = issues.filter { $0.status.lowercased() == "fail" }
        XCTAssertTrue(fails.isEmpty, "Native Role Partial should have zero Fail rows today (state-only defects are an undetected gap), got: \(fails.map(\.rule))")
    }

    // MARK: - Assertion helpers

    private func assertFires(
        _ issues: [A11yIssue],
        rule: String,
        elementContaining substring: String?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let matches = issues.filter { issue in
            issue.rule == rule
                && issue.status.lowercased() == "fail"
                && (substring == nil || issue.element.contains(substring!))
        }
        XCTAssertFalse(
            matches.isEmpty,
            "Expected a [FAIL] '\(rule)'\(substring.map { " for element containing '\($0)'" } ?? "") — none found. All issues: \(issues.map { "[\($0.status)] \($0.rule) — \($0.element)" })",
            file: file, line: line
        )
    }

    /// Checks no row at all — Fail, Validate, or otherwise — reports `rule` for an element
    /// containing `substring`. Deliberately not scoped to Fail-status rows: this is also
    /// used to confirm a manual-review Validate row was correctly suppressed once a more
    /// specific Fail exists for the same control.
    private func assertDoesNotFire(
        _ issues: [A11yIssue],
        rule: String,
        elementContaining substring: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let matches = issues.filter { issue in
            issue.rule == rule && issue.element.contains(substring)
        }
        XCTAssertTrue(
            matches.isEmpty,
            "Did not expect '\(rule)' for element containing '\(substring)', but found: \(matches.map { "[\($0.status)] \($0.rule) — \($0.element)" })",
            file: file, line: line
        )
    }
}
