//
//  ColorContrastPartialElementScanTests.swift
//  SwiftUIAccessibilityCheckerUITests
//
//  Element-level coverage for the two Colour Contrast PARTIAL screens, scanned one screen
//  class at a time.
//
//  The unifying property of this tier is CONFIGURATION DEPENDENCE. Every sample passes
//  somewhere: in light mode, at the default content size, at the left end of the gradient,
//  with Increase Contrast off, or on the part of the photo that happens to be dark. Test once,
//  in one configuration, and the whole screen looks compliant — which is what makes it the
//  tier that decides whether the ruleset is genuinely useful rather than merely present.
//
//  As on the Fail tier, the SwiftUI contrast path currently returns no verdict for any of
//  these controls, so the assertions split into reachability (true today, and what the
//  class-wise scan is for) and verdict (recorded as expected failures). The split is more
//  consequential here than on the Fail tier: a Fail screen that reports nothing is at least
//  obviously wrong to anyone who looks at it, whereas a Partial screen that reports nothing is
//  indistinguishable from a Partial screen that is genuinely clean.
//
import XCTest

final class ColorContrastPartialElementScanTests: XCTestCase {

    private let solidScreen = "AccessibleTextContrastPartial"
    private let compositedScreen = "AccessibleTextContrastCompositedPartial"

    private var solidFile: String { "\(solidScreen).swift" }
    private var compositedFile: String { "\(compositedScreen).swift" }

    // MARK: - Reachability

    /// All ten controls on the solid-background Partial screen are found and attributed.
    func testContrastPartial_allTenControlsAreReachedAndAttributed() throws {
        let issues = try runScan(screen: solidScreen, includePasses: true)
        XCTAssertEqual(taggedSourceLines(issues, sourceFile: solidFile),
                       [58, 63, 69, 80, 85, 89, 93, 98, 103, 116],
                       "Every control on the Partial screen should be reached and attributed "
                       + "to the line that declared it.")
    }

    /// The same for the composited Partial screen.
    func testCompositedPartial_allTenControlsAreReachedAndAttributed() throws {
        let issues = try runScan(screen: compositedScreen, includePasses: true)
        XCTAssertEqual(taggedSourceLines(issues, sourceFile: compositedFile),
                       [56, 63, 73, 79, 91, 99, 107, 121, 129, 140],
                       "Every control on the composited Partial screen should be reached and "
                       + "attributed to the line that declared it.")
    }

    /// Scanning by class scans only that class.
    func testContrastPartial_scanIsScopedToTheRequestedScreen() throws {
        let issues = try runScan(screen: solidScreen, includePasses: true)
        XCTAssertFalse(issues.isEmpty, "The scan returned nothing at all for \(solidScreen).")
        XCTAssertTrue(taggedRows(issues, sourceFile: compositedFile).isEmpty,
                      "Scanning \(solidScreen) also returned rows from \(compositedFile).")
    }

    // MARK: - Verdict — known gap

    /// Row 1 — body text at 4.478:1, twenty-two thousandths under the bar.
    ///
    /// The margin is the point. It is visually indistinguishable from the Pass screen's
    /// 4.54:1 sample, so no amount of looking at the screen finds it and a checker is the only
    /// thing that can. A sampler that reached this control but rounded to one decimal before
    /// comparing would report 4.5 and pass it — a different bug with the same outcome, and one
    /// this assertion would also catch once the control is measured at all.
    func testContrastPartial_bodyTextJustUnderAA_shouldFail() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        assertContrastFails(issues, forElementContaining: "Body text at 17pt")
    }

    /// Row 3 — 13pt bold at 3.44:1.
    ///
    /// Bold alone does not make text large: WCAG requires 14pt AND bold, so the bar here is
    /// 4.5:1 and this misses it. On SwiftUI the size is inferred from the element's frame
    /// height rather than read from the font, so this is the row where that inference has to
    /// come out right — and `assertContrastFails` rather than `assertContrast(is:)` is used
    /// deliberately, since pinning the exact rule would pin a padding value rather than an
    /// accessibility fact.
    func testContrastPartial_boldButUnder14pt_shouldFail() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        assertContrastFails(issues, forElementContaining: "Bold, but only 13pt")
    }

    /// Rows 6 and 7 — 4.95:1 and 5.33:1, which clear AA and fall short of AAA.
    ///
    /// The false-positive guard for this tier, and the one assertion here that is not simply
    /// "should have failed". A rule that quietly applied the 7:1 AAA bar would flag both while
    /// every other assertion in this file still passed, so these have to be measured AND come
    /// out clean — which is why the missing verdict makes this tier unverifiable in both
    /// directions rather than merely under-reported.
    func testContrastPartial_ratiosThatPassAAButNotAAA_shouldBeMeasuredAndClean() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        assertContrastPasses(issues, forElementContaining: "Arriving Thursday")
    }

    /// The composited Partial screen — row 2, a 0.6-alpha panel leaving white text at 4.47:1.
    ///
    /// Three hundredths under AA, on a panel that looks solidly dark and is not. The assigned
    /// pairing computes to 17:1, so this is a row where reading the source and reading the
    /// screen disagree by an order of magnitude — and the screenshot sampler is the half of
    /// the pair that would get it right.
    func testCompositedPartial_backgroundAlpha_shouldFailOnceComposited() throws {
        XCTExpectFailure("The SwiftUI contrast path produces no verdict for these controls.")
        let issues = try runScan(screen: compositedScreen, includePasses: true)
        assertContrastFails(issues, forElementContaining: "White text on a translucent panel")
    }

    /// The navigation-title false positive, as on the Fail tier.
    func testContrastPartial_navigationTitleIsNotAContrastFailure() throws {
        XCTExpectFailure("The navigation title's frame is sampled as white-on-white and "
                         + "reported as a large-text contrast failure.")
        let issues = try runScan(screen: solidScreen, includePasses: true)
        let titleRows = contrastRows(issues, forElementContaining: "Text Contrast (Partial)")
        XCTAssertTrue(titleRows.allSatisfy { ColorContrastRule.passes.contains($0.rule) },
                      "The navigation title should not be a contrast failure, got: "
                      + "\(titleRows.map(\.rule))")
    }
}
