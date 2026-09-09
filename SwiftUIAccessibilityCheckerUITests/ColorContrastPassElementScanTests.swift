//
//  ColorContrastPassElementScanTests.swift
//  SwiftUIAccessibilityCheckerUITests
//
//  Element-level coverage for the two Colour Contrast PASS screens, scanned one screen class
//  at a time.
//
//  This tier asserts the opposite of the other two, and on SwiftUI that asymmetry is sharper
//  than usual. A rule that reports nothing satisfies "no failures were reported" perfectly, so
//  on a Pass screen the absence of findings is not evidence of anything — and absence is
//  exactly what the SwiftUI contrast path currently produces here.
//
//  That is why every verdict assertion below asks for a PASS row rather than for the lack of a
//  failure row: `assertContrastPasses` fails when a control was never measured, which is the
//  only way this tier can distinguish "the rule looked and was satisfied" from "the rule never
//  ran". Those rows come from `all_passes`, which the report omits by default, so each scan
//  here asks for them explicitly.
//
import XCTest

final class ColorContrastPassElementScanTests: XCTestCase {

    private let solidScreen = "AccessibleTextContrastPass"
    private let compositedScreen = "AccessibleTextContrastCompositedPass"

    private var solidFile: String { "\(solidScreen).swift" }
    private var compositedFile: String { "\(compositedScreen).swift" }

    // MARK: - Reachability

    /// All ten controls on the solid-background Pass screen are found and attributed.
    func testContrastPass_allTenControlsAreReachedAndAttributed() throws {
        let issues = try runScan(screen: solidScreen, includePasses: true)
        XCTAssertEqual(taggedSourceLines(issues, sourceFile: solidFile),
                       [53, 58, 63, 75, 81, 85, 89, 95, 101, 111],
                       "Every control on the Pass screen should be reached and attributed to "
                       + "the line that declared it.")
    }

    /// The same for the composited Pass screen.
    func testCompositedPass_allTenControlsAreReachedAndAttributed() throws {
        let issues = try runScan(screen: compositedScreen, includePasses: true)
        XCTAssertEqual(taggedSourceLines(issues, sourceFile: compositedFile),
                       [60, 65, 74, 80, 87, 94, 103, 116, 125, 138],
                       "Every control on the composited Pass screen should be reached and "
                       + "attributed to the line that declared it.")
    }

    /// Scanning by class scans only that class.
    func testContrastPass_scanIsScopedToTheRequestedScreen() throws {
        let issues = try runScan(screen: solidScreen, includePasses: true)
        XCTAssertFalse(issues.isEmpty, "The scan returned nothing at all for \(solidScreen).")
        XCTAssertTrue(taggedRows(issues, sourceFile: compositedFile).isEmpty,
                      "Scanning \(solidScreen) also returned rows from \(compositedFile).")
    }

    // MARK: - Verdict — known gap

    /// Rows 1, 5 and 7 — 7.00:1, clearing AA and AAA both.
    ///
    /// Body text, a 13pt caption and a 13pt semibold header. The two small ones carry the
    /// weight: small text gets no relaxation, so their being clean is a statement about the
    /// colour rather than about the size, and it is the direct counterpart to the Partial
    /// screen's 3.44:1 caption at the same size in the same position.
    func testContrastPass_bodyCaptionAndHeader_shouldBeMeasuredAndPass() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls, "
                         + "so a passing ratio cannot be distinguished from an unmeasured one.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        assertContrastPasses(issues, forElementContaining: "Body text at 17pt")
        assertContrastPasses(issues, forElementContaining: "Last updated 3 minutes ago")
        assertContrastPasses(issues, forElementContaining: "CONNECTIVITY")
    }

    /// Row 10 — a DISABLED control title.
    ///
    /// WCAG 1.4.3 exempts text that is part of an inactive control, so this has no minimum
    /// ratio at all. It is legible anyway, which is good practice — but the row exists to
    /// prove that flagging it would be a false positive, and a rule that never measures it
    /// cannot demonstrate that it knows the difference. It passes for the wrong reason today.
    func testContrastPass_disabledControlTitle_shouldBeMeasuredAndNotFlagged() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        assertContrastPasses(issues, forElementContaining: "Save Draft")
    }

    /// The composited Pass screen — row 2, a 0.85-alpha panel compositing to about #3E3E40 for
    /// 10.67:1.
    ///
    /// The mirror of the Partial screen's 0.6-alpha panel: same construction, same assigned
    /// colours, only the alpha differs. The pair has to be read together, because a rule that
    /// ignored alpha entirely would report both as 17:1 and get this one right by accident.
    func testCompositedPass_backgroundAlpha_shouldBeMeasuredAndPass() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls.")
        let issues = try runScan(screen: compositedScreen, includePasses: true)
        assertContrastPasses(issues, forElementContaining: "White text on a translucent panel")
    }

    /// Row 7 — a caption over an image behind a 55% scrim, 6.53:1 at its worst point.
    ///
    /// The scrim is the recommended fix for captions over photography and is what makes the
    /// ratio predictable at all. Worth asserting on its own because its UIKit counterpart is
    /// currently reported as a failure — penalising the correct construction — so this is a
    /// row where the two platforms are wrong in opposite directions.
    func testCompositedPass_scrimmedCaptionOverImage_shouldBeMeasuredAndPass() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls.")
        let issues = try runScan(screen: compositedScreen, includePasses: true)
        assertContrastPasses(issues, forElementContaining: "Caption over a photo")
    }

    /// The whole solid screen, counted.
    ///
    /// The tier-level statement the other assertions build up to: every control the screen
    /// declares was measured, and none of them is a failure. Asserting the inventory and the
    /// verdict together is what makes it meaningful — either half alone is satisfied by a rule
    /// that has stopped running.
    func testContrastPass_everyTaggedControlShouldBeMeasuredAndClean() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no contrast rows for this "
                         + "screen's controls, so the tagged-row count is zero.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        let tagged = taggedContrastRows(issues, sourceFile: solidFile)
        XCTAssertEqual(tagged.count, 10,
                       "Expected all ten tagged controls to be measured, got: \(tagged.map(\.element))")
        XCTAssertTrue(tagged.allSatisfy { ColorContrastRule.passes.contains($0.rule) },
                      "No control on the Pass screen should be a contrast failure, got: "
                      + "\(tagged.filter { !ColorContrastRule.passes.contains($0.rule) }.map(\.element))")
    }

    /// The navigation-title false positive, as on the other two tiers.
    ///
    /// It is at its most misleading here: the only contrast finding on a screen whose ten
    /// controls are all correct, so the report shows one failure and it is the one thing on
    /// the screen that was never a defect.
    func testContrastPass_navigationTitleIsNotAContrastFailure() throws {
        XCTExpectFailure("The navigation title's frame is sampled as white-on-white and "
                         + "reported as a large-text contrast failure.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        let titleRows = contrastRows(issues, forElementContaining: "Text Contrast (Pass)")
        XCTAssertTrue(titleRows.allSatisfy { ColorContrastRule.passes.contains($0.rule) },
                      "The navigation title should not be a contrast failure, got: "
                      + "\(titleRows.map(\.rule))")
    }
}
