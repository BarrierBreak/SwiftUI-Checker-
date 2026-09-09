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

    /// Play/Pause carries `.accessibilityValue(isPlaying ? "Playing" : "Paused")`, so its
    /// state is wired correctly and none of the four rules should have anything to say about
    /// it. Worth asserting rather than omitting: this is a native `Button { ident.toggle() }`,
    /// the shape the source scan reaches only through the Button anchor, so a false positive
    /// here would mean that anchor is matching the chain but misreading it. The Partial tier's
    /// own Play/Pause covers the missing-value side of the same shape.
    func testAccessibleStateFail_playPauseButton_isCorrectlyWired() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        assertVerifies(issues, elementContaining: "Play")
        assertOnlyRule(issues, rule: verifyUpdates, elementContaining: "Play")
    }

    /// Step tracker: `.accessibilityAddTraits([.isButton, .isSelected])` unconditionally, so
    /// all four steps announce themselves as current at once.
    func testAccessibleStateFail_stepTracker_everyStepClaimsToBeSelected() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        assertFires(issues, rule: incorrect, elementContaining: "Cart")
        assertOnlyRule(issues, rule: incorrect, elementContaining: "Cart")
    }

    /// The email field is unlabeled, so it is pinned by rule rather than element text: its
    /// `.accessibilityValue("Empty")` is present but fixed, hence "incorrect" rather than
    /// "missing".
    ///
    /// The busy Submit button next to it is deliberately NOT asserted. Its only label is a
    /// `ProgressView()`, and whether SwiftUI publishes that button as an accessibility element
    /// at all varies by device and by when the scan lands relative to the spinner's animation
    /// — it appears on some simulators and not others. The source-level finding for it is
    /// stable (BUSY_STATE_WITHOUT_VALUE at AccessibleStateFail.swift:129); only its presence
    /// in the live tree is not, so asserting it here would buy a flaky test rather than
    /// coverage.
    func testAccessibleStateFail_unlabeledEmailField_hasAFixedValue() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        let unnamed = issues.filter { stateRules.contains($0.rule) && $0.element.hasPrefix("no name") }
        XCTAssertTrue(
            unnamed.contains { $0.rule == incorrect },
            "Expected the unlabeled email field to report an incorrect state value, got: \(unnamed.map { "\($0.rule) — \($0.element)" })"
        )
    }

    /// The whole screen at once: five provable defects, plus Play/Pause asking to be
    /// confirmed (it is correctly wired). Two controls report nothing, each for its own
    /// reason — the disclosure row is `.accessibilityHidden(true)`, so it never becomes a
    /// live element for any finding to attach to, and the "Continue" button carries no source
    /// signal that its availability is conditional at all (no guard, no dimming, no
    /// `.disabled`), so it is left to a human by design.
    func testAccessibleStateFail_stateRuleCoverage() throws {
        let issues = try runScan(screen: "AccessibleStateFail")
        let rows = issues.filter { stateRules.contains($0.rule) }

        // Pinned by element rather than by a total, because one row on this screen is not
        // deterministic: the busy Submit button's only label is a ProgressView, and whether
        // SwiftUI publishes it as an element varies by device (see
        // testAccessibleStateFail_unlabeledEmailField_hasAFixedValue).
        for (element, rule) in [("All", notUpdated), ("I agree to the Terms of Service", incorrect),
                                ("Cart", incorrect), ("Play", verifyUpdates)] {
            XCTAssertTrue(
                rows.contains { $0.rule == rule && $0.element.contains(element) },
                "Expected '\(rule)' for '\(element)', got: \(rows.map { "\($0.rule) — \($0.element)" })"
            )
        }
        XCTAssertTrue((5...6).contains(rows.count),
                      "Expected five or six state rows, got: \(rows.map { "\($0.rule) — \($0.element)" })")
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

    /// `.accessibilityValue(wifiStatusText)` reads a computed property that does correctly
    /// track `wifiEnabled` — the scan resolves one level into the property's body to
    /// establish that, so this row is not a defect. What it gets instead is the
    /// manual-confirmation row: the wiring is right, and only using the control proves the
    /// announcement actually changes.
    func testAccessibleStatePartial_wifiRow_isWiredAndAsksForConfirmation() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        assertVerifies(issues, elementContaining: "Wi-Fi")
        assertOnlyRule(issues, rule: verifyUpdates, elementContaining: "Wi-Fi")
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

    /// All ten controls on this screen report a state rule: nine provable defects, plus the
    /// Wi-Fi row, whose wiring is correct and so gets the manual-confirmation row instead.
    func testAccessibleStatePartial_everyControlReportsAStateRule() throws {
        let issues = try runScan(screen: "AccessibleStatePartial")
        let rows = issues.filter { stateRules.contains($0.rule) }
        XCTAssertEqual(rows.count, 10, "Expected ten state rows, got: \(rows.map { "\($0.rule) — \($0.element)" })")
        XCTAssertEqual(rows.filter { $0.status.lowercased() == "validate" }.count, 1,
                       "Only the correctly-wired Wi-Fi row should be Validate: \(rows.map { "[\($0.status)] \($0.element)" })")
    }

    // MARK: - AccessibleStatePass

    /// The reference tier: every control keeps its accessibility state in sync in the same
    /// code path that changes its appearance, so nothing here is a defect — and every one of
    /// them reports the manual-confirmation row instead, because "the source is right" and
    /// "the announcement actually changes when used" are different claims.
    func testAccessibleStatePass_reportsNoStateDefect() throws {
        let issues = try runScan(screen: "AccessibleStatePass")
        let defects = issues.filter { stateRules.contains($0.rule) && $0.status.lowercased() == "fail" }
        XCTAssertTrue(
            defects.isEmpty,
            "State Pass must report no state defect, got: \(defects.map { "\($0.rule) — \($0.element)" })"
        )
    }

    func testAccessibleStatePass_everyControlAsksForConfirmation() throws {
        let issues = try runScan(screen: "AccessibleStatePass")
        for control in ["All", "Shipping details", "I agree to the Terms of Service",
                        "Continue", "Submit", "Play", "Cart"] {
            assertVerifies(issues, elementContaining: control)
        }
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

    /// Asserts the element reports the manual-confirmation row: its state is wired, no defect
    /// was found in it, and a person still has to use it to hear whether the announcement
    /// changes. Checked as Validate specifically — a Fail-status row carrying the same rule
    /// text would mean the tier split has broken.
    private func assertVerifies(
        _ issues: [A11yIssue],
        elementContaining substring: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let matches = issues.filter { issue in
            issue.rule == verifyUpdates
                && issue.status.lowercased() == "validate"
                && issue.element.contains(substring)
        }
        XCTAssertFalse(
            matches.isEmpty,
            "Expected a [Validate] '\(verifyUpdates)' for element containing '\(substring)' — none found. All issues: \(issues.map { "[\($0.status)] \($0.rule) — \($0.element)" })",
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
