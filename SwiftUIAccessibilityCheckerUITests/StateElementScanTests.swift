import XCTest

/// Element-level regression coverage for the three State screens, mirroring
/// RoleElementScanTests.swift's assertFires/assertDoesNotFire pattern.
///
/// Every interactive control on Fail and Partial reports exactly one of the four state
/// rules, and every control on Pass reports none. Each test names the control it is about
/// and asserts the other three rules do NOT fire on it, so a rule drifting from "missing"
/// to "not updated" (or a control quietly losing its finding entirely) fails loudly instead
/// of hiding inside a total count.
final class StateElementScanTests: XCTestCase {

    private let missing = "Missing state information for interactive control"
    private let incorrect = "Incorrect State value provided for interactive control"
    private let notUpdated = "State does not get updated on user interaction"
    private let verifyUpdates = "Verify if the state for interactive control gets updated on user interaction"

    private var stateRules: [String] { [missing, incorrect, notUpdated, verifyUpdates] }

    // MARK: - AccessibleStateFail

    /// Filter chips: `.accessibilityAddTraits(filter == filters.first ? …)` — a real ternary,
    /// keyed on a constant instead of the live `selectedFilter`, so `.isSelected` is pinned
    /// to the first chip no matter which one is actually chosen.
    func testAccessibleStateFail_filterChips_selectedTraitNeverFollowsSelection() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        assertFires(issues, rule: notUpdated, elementContaining: "All")
        assertOnlyRule(issues, rule: notUpdated, elementContaining: "All")
    }

    /// Checkbox: `agreedToTerms ? "Not checked" : "Checked"` — the ternary is backwards, so a
    /// consent control tells the user the opposite of what they chose.
    func testAccessibleStateFail_checkbox_valueIsInverted() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        assertFires(issues, rule: incorrect, elementContaining: "I agree to the Terms of Service")
        assertOnlyRule(issues, rule: incorrect, elementContaining: "I agree to the Terms of Service")
    }

    /// Play/Pause: `Button { isPlaying.toggle() }` with a fixed `.accessibilityLabel("Play")`
    /// and no value at all. Worth pinning specifically because the control is a native
    /// `Button` rather than an `.onTapGesture` — the shape the source scan used to miss.
    func testAccessibleStateFail_playPauseButton_hasNoStateValue() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        assertFires(issues, rule: missing, elementContaining: "Play")
        assertOnlyRule(issues, rule: missing, elementContaining: "Play")
    }

    /// Step tracker: `.accessibilityAddTraits([.isButton, .isSelected])` unconditionally, so
    /// all four steps announce themselves as current at once.
    func testAccessibleStateFail_stepTracker_everyStepClaimsToBeSelected() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        assertFires(issues, rule: incorrect, elementContaining: "Cart")
        assertOnlyRule(issues, rule: incorrect, elementContaining: "Cart")
    }

    /// The busy Submit button (an unlabeled ProgressView) and the unlabeled email field both
    /// report as "no name", so they are pinned by rule counts rather than by element text:
    /// the busy button is missing state entirely, the field's `.accessibilityValue("Empty")`
    /// is present but fixed.
    func testAccessibleStateFail_unlabeledBusyButtonAndEmailField() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        let unnamed = issues.filter { stateRules.contains($0.rule) && $0.element.hasPrefix("no name") }
        XCTAssertEqual(
            Set(unnamed.map(\.rule)), [missing, incorrect],
            "Expected the busy Submit button to report missing state and the email field to report an incorrect one, got: \(unnamed.map { "\($0.rule) — \($0.element)" })"
        )
    }

    /// The whole screen at once: six of its eight controls report a state rule. The
    /// disclosure row is the deliberate exception — it is `.accessibilityHidden(true)`, so it
    /// never becomes a live element and there is nothing for a finding to attach to, and the
    /// "Continue" button carries no source signal that its availability is conditional at
    /// all (no guard, no dimming), so it is left to a human by design.
    func testAccessibleStateFail_stateRuleCoverage() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        let rows = issues.filter { stateRules.contains($0.rule) }
        XCTAssertEqual(rows.count, 6, "Expected six state rows, got: \(rows.map { "\($0.rule) — \($0.element)" })")
    }

    // MARK: - AccessibleStatePartial

    func testAccessibleStatePartial_filterChips_haveNoSelectedTraitAtAll() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        assertFires(issues, rule: missing, elementContaining: "All")
        assertOnlyRule(issues, rule: missing, elementContaining: "All")
    }

    func testAccessibleStatePartial_disclosureRow_neverReportsExpandedOrCollapsed() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        assertFires(issues, rule: missing, elementContaining: "Shipping details")
        assertOnlyRule(issues, rule: missing, elementContaining: "Shipping details")
    }

    /// `.accessibilityValue("Not checked")` — a literal that cannot follow the checkbox.
    func testAccessibleStatePartial_checkbox_valueIsAFixedLiteral() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        assertFires(issues, rule: incorrect, elementContaining: "I agree to the Terms of Service")
        assertOnlyRule(issues, rule: incorrect, elementContaining: "I agree to the Terms of Service")
    }

    /// The copy-paste bug: this row toggles `notificationsEnabled`, but its value reads
    /// `agreedToTerms` — a real ternary that tracks a different control entirely.
    func testAccessibleStatePartial_notificationsRow_valueTracksTheWrongProperty() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        assertFires(issues, rule: notUpdated, elementContaining: "Notifications")
        assertOnlyRule(issues, rule: notUpdated, elementContaining: "Notifications")
    }

    /// The one Validate row on this screen: `.accessibilityValue(wifiStatusText)` reads a
    /// computed property, which does track `wifiEnabled` correctly — but nothing on that line
    /// proves it, so the scan asks rather than asserts.
    func testAccessibleStatePartial_wifiRow_asksForManualVerification() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        let rows = issues.filter { $0.rule == verifyUpdates && $0.element.contains("Wi-Fi") }
        XCTAssertFalse(rows.isEmpty, "Expected a Validate row for the Wi-Fi row, got: \(issues.filter { stateRules.contains($0.rule) }.map(\.element))")
        XCTAssertTrue(
            rows.allSatisfy { $0.status.lowercased() == "validate" },
            "The Wi-Fi row's finding must be Validate, not Fail — the value is unverifiable, not wrong"
        )
        assertDoesNotFire(issues, rule: missing, elementContaining: "Wi-Fi")
        assertDoesNotFire(issues, rule: incorrect, elementContaining: "Wi-Fi")
        assertDoesNotFire(issues, rule: notUpdated, elementContaining: "Wi-Fi")
    }

    /// Dimmed with `.opacity(isFormValid ? …)` and guarded internally, but never `.disabled()`,
    /// so VoiceOver announces a fully available control.
    func testAccessibleStatePartial_continueButton_isDimmedButNotDisabled() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        assertFires(issues, rule: missing, elementContaining: "Continue")
        assertOnlyRule(issues, rule: missing, elementContaining: "Continue")
    }

    /// Sets `isSubmitting` around an async block with no `.disabled()` and no value reading
    /// it — the spinner is the only cue, and a spinner is invisible to VoiceOver.
    func testAccessibleStatePartial_submitButton_busyStateIsNeverAnnounced() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        assertFires(issues, rule: missing, elementContaining: "Submit")
        assertOnlyRule(issues, rule: missing, elementContaining: "Submit")
    }

    /// The label flips to "Playing"/"Paused" (describing state instead of the action) and
    /// there is still no value, so the control reports as missing state.
    func testAccessibleStatePartial_playPauseButton_hasNoStateValue() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        assertFires(issues, rule: missing, elementContaining: "Paused")
        assertOnlyRule(issues, rule: missing, elementContaining: "Paused")
    }

    func testAccessibleStatePartial_stepTracker_hasNoSelectedTraitAtAll() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        assertFires(issues, rule: missing, elementContaining: "Cart")
        assertOnlyRule(issues, rule: missing, elementContaining: "Cart")
    }

    /// The email field is unlabeled, so it is pinned by rule rather than element text.
    func testAccessibleStatePartial_emailField_validatesWithoutAnnouncingValidity() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        let unnamed = issues.filter { stateRules.contains($0.rule) && $0.element.hasPrefix("no name") }
        XCTAssertEqual(
            unnamed.map(\.rule), [missing],
            "Expected exactly one unnamed control (the email field) reporting missing state, got: \(unnamed.map { "\($0.rule) — \($0.element)" })"
        )
    }

    /// All ten controls on this screen report a state rule — nine Fail, one Validate.
    func testAccessibleStatePartial_everyControlReportsAStateRule() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        let rows = issues.filter { stateRules.contains($0.rule) }
        XCTAssertEqual(rows.count, 10, "Expected ten state rows, got: \(rows.map { "\($0.rule) — \($0.element)" })")
        XCTAssertEqual(rows.filter { $0.status.lowercased() == "validate" }.count, 1,
                       "Exactly one control (the Wi-Fi row) should be Validate rather than Fail")
    }

    // MARK: - AccessibleStatePass

    /// The reference tier: every control keeps its accessibility state in sync in the same
    /// code path that changes its appearance, so none of the four rules has anything to say.
    func testAccessibleStatePass_reportsNoStateRuleAtAll() throws {
        let issues = try runScan(screen: "AccessibleStatePass")
        let rows = issues.filter { stateRules.contains($0.rule) }
        XCTAssertTrue(
            rows.isEmpty,
            "State Pass must report none of the four state rules, Fail or Validate, got: \(rows.map { "[\($0.status)] \($0.rule) — \($0.element)" })"
        )
    }

    // MARK: - Assertion helpers (same shape as RoleElementScanTests.swift's own)

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

    /// Asserts `rule` is the ONLY one of the four state rules reported for this element — the
    /// point being that these four outcomes are mutually exclusive per control, so a control
    /// reported as both "missing" and "not updated" is a routing bug even though each row on
    /// its own looks plausible.
    private func assertOnlyRule(
        _ issues: [A11yIssue],
        rule: String,
        elementContaining substring: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        for other in stateRules where other != rule {
            assertDoesNotFire(issues, rule: other, elementContaining: substring, file: file, line: line)
        }
    }
}
