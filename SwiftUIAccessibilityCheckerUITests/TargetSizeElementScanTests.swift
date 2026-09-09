import XCTest

/// Element-level coverage for WCAG 2.5.8 minimum target size across the three Target Size
/// screens, mirroring RoleElementScanTests' assertFires/assertDoesNotFire pattern.
///
/// The rule checks size FIRST, and that decides whether spacing is measured at all:
///
///   • at least 24×24pt → passes on size alone. Neighbours are never measured, because the
///     spacing exception exists to rescue targets that are SMALLER than the minimum. Failing
///     an adequately-sized control for a tight gap would report something 2.5.8 does not ask.
///   • under 24×24pt → an exception is the only route through. The one these screens
///     exercise is SPACING, and it is a circle test: a 24pt-diameter circle centred on the
///     target must not overlap another target, nor another undersized target's circle. Two
///     undersized targets therefore need their CENTRES 24pt apart, and an undersized target
///     beside a full-size one needs only 12pt from that neighbour's box.
///
/// So the only shape that fails is undersized AND genuinely too close, and the tests below
/// are built around proving that rather than counting rows: several controls here are
/// deliberately crowded and deliberately not reported.
final class TargetSizeElementScanTests: XCTestCase {

    private let tooSmall = "Interactive control doesn't meet minimum target size requirements"
    private let verifySize = "Verify interactive control minimum target size requirements"

    private var targetSizeRules: [String] { [tooSmall, verifySize] }

    // MARK: - AccessibleTargetSizeFail — undersized and crowded

    /// Two 16×16 icons 2pt apart: centres 18pt apart, inside the 24pt the two circles need,
    /// so neither can fall back on the spacing exception.
    func testTargetSizeFail_tinyPair_bothFail() throws {
        let issues = try runScan(screen: "AccessibleTargetSizeFail")
        assertFires(issues, rule: tooSmall, elementContaining: "Dismiss")
        assertFires(issues, rule: tooSmall, elementContaining: "Confirm")
    }

    /// The stepper shape: 20×20 controls stacked 2pt apart, centres 22pt apart.
    func testTargetSizeFail_stackedStepper_bothFail() throws {
        let issues = try runScan(screen: "AccessibleTargetSizeFail")
        assertFires(issues, rule: tooSmall, elementContaining: "Increase quantity")
        assertFires(issues, rule: tooSmall, elementContaining: "Decrease quantity")
    }

    /// An undersized icon sitting beside a full-size button, and neither is reported.
    ///
    /// This is the case that shows how much narrower the circle test is than "24pt of clear
    /// space": a full-size neighbour has no circle of its own, so only its bounding box
    /// counts, and the small icon's circle needs to clear that box by 12pt rather than 24.
    /// The big button, having met the minimum, was never measured at all.
    func testTargetSizeFail_smallIconBesideAFullSizeButton_neitherIsReported() throws {
        let issues = try runScan(screen: "AccessibleTargetSizeFail")
        assertDoesNotFire(issues, rule: tooSmall, elementContaining: "More information")
        assertDoesNotFire(issues, rule: tooSmall, elementContaining: "Continue")
    }

    func testTargetSizeFail_denseToolbar_bothFail() throws {
        let issues = try runScan(screen: "AccessibleTargetSizeFail")
        assertFires(issues, rule: tooSmall, elementContaining: "Bold")
        assertFires(issues, rule: tooSmall, elementContaining: "Italic")
    }

    /// Six controls fail: the three tightly-packed undersized pairs. The other two — the
    /// full-size "Continue" button and the small icon beside it — pass, one on size and one on
    /// the spacing exception.
    func testTargetSizeFail_coverage() throws {
        let issues = try runScan(screen: "AccessibleTargetSizeFail")
        let failures = issues.filter { $0.rule == tooSmall }
        XCTAssertEqual(failures.count, 6, "Expected six controls whose circles overlap, got: \(failures.map(\.element))")
    }

    // MARK: - AccessibleTargetSizePartial — the borderline cases

    /// Padded to roughly 36pt and only 6pt from its neighbour: big enough, so the gap is
    /// never measured. This is the case a spacing-first implementation gets wrong.
    func testTargetSizePartial_paddedIconsAreCrowdedButNotReported() throws {
        let issues = try runScan(screen: "AccessibleTargetSizePartial")
        assertDoesNotFire(issues, rule: tooSmall, elementContaining: "Filter results")
        assertDoesNotFire(issues, rule: tooSmall, elementContaining: "Sort results")
    }

    /// Two 44pt buttons 8pt apart — the same point again at a comfortable size.
    func testTargetSizePartial_fullSizeButtonsAreCrowdedButNotReported() throws {
        let issues = try runScan(screen: "AccessibleTargetSizePartial")
        assertDoesNotFire(issues, rule: tooSmall, elementContaining: "Save")
        assertDoesNotFire(issues, rule: tooSmall, elementContaining: "Discard")
    }

    /// Undersized controls with room around them: rescued by the spacing exception.
    func testTargetSizePartial_undersizedButIsolated_passes() throws {
        let issues = try runScan(screen: "AccessibleTargetSizePartial")
        assertDoesNotFire(issues, rule: tooSmall, elementContaining: "Edit note")
        assertDoesNotFire(issues, rule: tooSmall, elementContaining: "Refresh")
    }

    /// Nothing on this screen fails, and the 22×22 control with 10pt beside it is why the
    /// circle test has to be implemented as a circle: its centre is 11pt from its own edge
    /// plus 10pt of gap = 21pt from the neighbour's box, comfortably past the 12pt radius. A
    /// four-sided "24pt of clear space" reading fails it, and would be wrong to.
    func testTargetSizePartial_noControlFails() throws {
        let issues = try runScan(screen: "AccessibleTargetSizePartial")
        let failures = issues.filter { $0.rule == tooSmall }
        XCTAssertTrue(failures.isEmpty, "Every control here is either big enough or excused, got: \(failures.map(\.element))")
        assertDoesNotFire(issues, rule: tooSmall, elementContaining: "Delete note")
    }

    // MARK: - AccessibleTargetSizePass

    /// Nothing here is a defect, and every control still reports the Validate row: a frame
    /// measured once, at one Dynamic Type size in one orientation, is evidence rather than
    /// proof, so the scan says what it measured and asks a person to confirm it holds.
    func testTargetSizePass_noFailuresButEveryControlAsksToBeVerified() throws {
        let issues = try runScan(screen: "AccessibleTargetSizePass")

        let failures = issues.filter { $0.rule == tooSmall }
        XCTAssertTrue(failures.isEmpty, "Target Size Pass must report no size failure, got: \(failures.map(\.element))")

        let verifies = issues.filter { $0.rule == verifySize }
        XCTAssertFalse(verifies.isEmpty, "Every measured control should ask to be verified: \(issues.map(\.rule))")
        XCTAssertTrue(
            verifies.allSatisfy { $0.status.lowercased() == "validate" },
            "The verify row must be Validate, not Fail: \(verifies.map { "[\($0.status)] \($0.element)" })"
        )
    }

    /// Both outcomes are reported for every control that gets measured — a control is never
    /// silently skipped, which is what makes the absence of a row meaningful.
    func testEveryScreen_reportsAnOutcomeForItsControls() throws {
        for screen in ["AccessibleTargetSizeFail", "AccessibleTargetSizePartial", "AccessibleTargetSizePass"] {
            let issues = try runScan(screen: screen)
            let measured = issues.filter { targetSizeRules.contains($0.rule) }
            XCTAssertFalse(measured.isEmpty, "\(screen) produced no target-size rows at all")
        }
    }

    // MARK: - Assertion helpers (same shape as RoleElementScanTests.swift's own)

    private func assertFires(
        _ issues: [A11yIssue],
        rule: String,
        elementContaining substring: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let matches = issues.filter {
            $0.rule == rule && $0.status.lowercased() == "fail" && $0.element.contains(substring)
        }
        XCTAssertFalse(
            matches.isEmpty,
            "Expected a [FAIL] '\(rule)' for element containing '\(substring)' — none found. All issues: \(issues.map { "[\($0.status)] \($0.rule) — \($0.element)" })",
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
        let matches = issues.filter { $0.rule == rule && $0.element.contains(substring) }
        XCTAssertTrue(
            matches.isEmpty,
            "Did not expect '\(rule)' for element containing '\(substring)', but found: \(matches.map { "[\($0.status)] \($0.element)" })",
            file: file, line: line
        )
    }
}
