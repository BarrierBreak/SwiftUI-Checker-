//
//  ColorContrastFailElementScanTests.swift
//  SwiftUIAccessibilityCheckerUITests
//
//  Element-level coverage for the two Colour Contrast FAIL screens, scanned one screen class
//  at a time so a tier can be run on its own and a failure names the tier it came from.
//
//  What this suite can assert is narrower than its UIKit counterpart, and the reason is worth
//  stating rather than working around. On UIKit the rule reads the assigned colours and the
//  font directly, so a ratio and a threshold are both facts. On SwiftUI neither is exposed
//  through the accessibility APIs, so the rule falls back to cropping the element's frame out
//  of a window snapshot and clustering the pixels by luminance — and on these screens that
//  path currently produces no verdict at all for any of the ten controls.
//
//  So the assertions split in two:
//
//    • REACHABILITY — every control the screen declares is found by the scan, is attributed
//      to the source line that declared it, and is reported under the screen it belongs to.
//      This is true today and is what makes the class-wise scan useful even while the
//      contrast verdict is missing: it proves the traversal and the `.srcLine()` attribution
//      work, which is what a report row needs in order to point at anything.
//    • VERDICT — the contrast conclusion itself, recorded as expected failures. Left out
//      entirely, a reader would have to infer from absence that the tier is unchecked; a
//      green suite that never mentions contrast is exactly how a gap this size stays
//      invisible.
//
import XCTest

final class ColorContrastFailElementScanTests: XCTestCase {

    private let solidScreen = "AccessibleTextContrastFail"
    private let compositedScreen = "AccessibleTextContrastCompositedFail"

    private var solidFile: String { "\(solidScreen).swift" }
    private var compositedFile: String { "\(compositedScreen).swift" }

    // MARK: - Reachability

    /// All ten controls on the solid-background Fail screen are found and attributed.
    ///
    /// The line numbers are asserted as a set rather than a count. A count survives two
    /// controls collapsing into one merged accessibility element as long as some other row
    /// appears, which is the most common way a SwiftUI screen loses coverage — the exact lines
    /// do not.
    func testTextContrastFail_allTenControlsAreReachedAndAttributed() throws {
        let issues = try runScan(screen: solidScreen, includePasses: true)
        XCTAssertEqual(taggedSourceLines(issues, sourceFile: solidFile),
                       [46, 51, 56, 67, 71, 77, 82, 88, 93, 99],
                       "Every control on the Fail screen should be reached and attributed to "
                       + "the line that declared it.")
    }

    /// The same for the composited Fail screen.
    ///
    /// This one matters more: alpha, stacked layers, materials and gradients are the
    /// constructions most likely to make SwiftUI merge or drop an element, so reaching all ten
    /// is not a foregone conclusion the way it is on a screen of plain Text views.
    func testCompositedFail_allTenControlsAreReachedAndAttributed() throws {
        let issues = try runScan(screen: compositedScreen, includePasses: true)
        XCTAssertEqual(taggedSourceLines(issues, sourceFile: compositedFile),
                       [50, 56, 67, 71, 85, 91, 100, 107, 116, 127],
                       "Every control on the composited Fail screen should be reached and "
                       + "attributed to the line that declared it.")
    }

    /// Scanning by class scans only that class.
    ///
    /// The whole premise of a per-tier suite is that `--a11y-screen` scopes the scan, so a
    /// failure names one screen instead of arriving from a combined report. If the scoping
    /// silently fell back to scanning everything, every other assertion here would still pass
    /// while pointing at the wrong screen.
    func testTextContrastFail_scanIsScopedToTheRequestedScreen() throws {
        let issues = try runScan(screen: solidScreen, includePasses: true)
        XCTAssertFalse(issues.isEmpty, "The scan returned nothing at all for \(solidScreen).")
        XCTAssertTrue(taggedRows(issues, sourceFile: compositedFile).isEmpty,
                      "Scanning \(solidScreen) also returned rows from \(compositedFile).")

        // The report's `screen` field is the demo's own label plus the class in parentheses —
        // "Text Contrast Fail (AccessibleTextContrastFail)" — rather than the navigation
        // title the screen displays. Matching on the class name is what makes this exact:
        // the label is prose that can be reworded, and "AccessibleTextContrastFail" is not a
        // substring of "AccessibleTextContrastCompositedFail", so a stray row from the
        // composited screen would still be caught.
        let otherScreens = Set(issues.map(\.screen)).filter { !$0.contains(solidScreen) }
        XCTAssertTrue(otherScreens.isEmpty,
                      "Expected only the Fail screen in the report, also got: \(otherScreens)")
    }

    // MARK: - Verdict — known gap
    //
    // Every ratio on both screens is below 3:1, the LARGE-text floor, so no control here needs
    // the large-vs-normal classification to be right in order to be a failure. There is no
    // threshold subtlety to get wrong and no configuration in which any of them passes: if the
    // rule measured these controls at all, all twenty would be failures.

    /// The solid Fail screen: ten controls between 1.00:1 and 2.48:1, none of them reported.
    ///
    /// Row 10 is the clearest of them — white text on a white background, 1.00:1, invisible on
    /// screen and still announced by VoiceOver. A pixel-clustering sampler has nothing to
    /// cluster there, which is a real limitation of the approach rather than an oversight; but
    /// it is also the row where the announced content and the visible content diverge most, so
    /// silence is the least useful possible answer.
    func testTextContrastFail_controlsShouldBeMeasured() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls — "
                         + "no pass, no failure, and no request for a manual check.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        assertContrastFails(issues, forElementContaining: "Body text at 17pt")
    }

    /// The composited Fail screen, same shape.
    ///
    /// Three of its rows read as the HIGHEST-contrast pairings on the screen if the assigned
    /// colour is used instead of the composited one, so this tier is where a source-reading
    /// checker does its worst work. A screenshot sampler is the right tool for exactly this
    /// case — it sees the rendered result and cannot be fooled by the source — which is what
    /// makes the missing verdict here the more costly of the two.
    func testCompositedFail_controlsShouldBeMeasured() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls.")
        let issues = try runScan(screen: compositedScreen, includePasses: true)
        assertContrastFails(issues, forElementContaining: "White text on a translucent panel")
    }

    /// The one contrast row each screen DOES produce is a false positive on the navigation
    /// title, sampled as #FFFFFF on #FFFFFF for 1.00:1.
    ///
    /// The large-title area is mostly empty, so a crop of its frame finds white on white and
    /// reports the ratio as if the title were invisible. It is worth pinning separately from
    /// the missing verdicts: the two look like one bug from the summary counts — "one contrast
    /// finding on a screen with ten broken controls" — but they are opposite failures, and
    /// fixing the sampler to reach the controls would not on its own stop the title being
    /// mis-sampled.
    func testTextContrastFail_navigationTitleIsNotAContrastFailure() throws {
        XCTExpectFailure("The navigation title's frame is sampled as white-on-white and "
                         + "reported as a large-text contrast failure.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        let titleRows = contrastRows(issues, forElementContaining: "Text Contrast (Fail)")
        XCTAssertTrue(titleRows.allSatisfy { ColorContrastRule.passes.contains($0.rule) },
                      "The navigation title should not be a contrast failure, got: "
                      + "\(titleRows.map(\.rule))")
    }
}
