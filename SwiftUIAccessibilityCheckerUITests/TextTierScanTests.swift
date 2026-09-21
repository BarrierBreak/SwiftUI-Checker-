//
//  TextTierScanTests.swift
//  SwiftUIAccessibilityCheckerUITests
//
//  Per-element coverage for the two text families' Pass/Fail/Partial tiers (WCAG 1.4.4):
//
//    • AccessibleTextResize{Pass,Fail,Partial}    — BB40032 / BB40031
//    • AccessibleTextClipping{Pass,Fail,Partial}  — BB40030 / BB40033
//
//  HOW SWIFTUI REACHES THESE VERDICTS
//
//  Not the way UIKit does. `_UIHostingView` has no subviews — SwiftUI draws its text directly
//  rather than into a UILabel — so there is no rendered label to read a font off and no
//  contentSize to compare against bounds. Both families are answered from source instead, by
//  the linter's SWIFTUI_FIXED_FONT_SIZE / SWIFTUI_SCALABLE_FONT and SWIFTUI_TEXT_CLIPPED /
//  SWIFTUI_TEXT_NOT_CLIPPED checks, matched back to live elements by the "<basename>:<line>"
//  identity `.srcLine()` writes.
//
//  For resize that is as definitive as the UIKit answer: `.font(.system(size:))` has no
//  scaling form, and `.font(.custom(…))` scales only with `relativeTo:`. For clipping it is
//  weaker — a verdict about configuration rather than a measurement — so the Fail shape
//  requires a fixed frame AND a line cap AND an explicit truncation mode before it fires.
//
//  Counts are exact rather than "contains", because the interesting property of these tiers
//  is the split: a Fail screen where two of five elements quietly pass would satisfy a
//  `contains` assertion while being wrong.
//
import XCTest

final class TextTierScanTests: XCTestCase {

    private let manualReviewTitle = "Check if interactive control name is descriptive"

    private let resizePass = "Text can be resized"
    private let resizeFail = "Text fails to resize"
    private let clipPass = "Text is not getting clipped"
    private let clipFail = "Text getting clipped"

    private func counts(_ screen: String, family: String) throws -> [String: Int] {
        let rows = try runScan(screen: screen, family: family, includePasses: true)
            .filter { $0.rule != manualReviewTitle }
        return Dictionary(grouping: rows, by: { $0.rule }).mapValues(\.count)
    }

    // MARK: - Resize

    func testTextResizePass_everyTextScales() throws {
        let c = try counts("AccessibleTextResizePass", family: "textResize")
        XCTAssertEqual(c[resizePass], 5, "All five use a Dynamic Type text style")
        XCTAssertNil(c[resizeFail], "Nothing on the Pass tier may fail to resize")
    }

    func testTextResizeFail_noTextScales() throws {
        let c = try counts("AccessibleTextResizeFail", family: "textResize")
        XCTAssertEqual(c[resizeFail], 5, "All five use a fixed point size")
        XCTAssertNil(c[resizePass], "Nothing on the Fail tier may pass")
    }

    func testTextResizePartial_reportsBothOutcomes() throws {
        let c = try counts("AccessibleTextResizePartial", family: "textResize")
        XCTAssertEqual(c[resizePass], 3, "Title, body and footnote were migrated")
        XCTAssertEqual(c[resizeFail], 2, "The badge and tab caption are still hard-coded")
    }

    // MARK: - Clipping

    func testTextClippingPass_nothingIsClipped() throws {
        let c = try counts("AccessibleTextClippingPass", family: "textClipping")
        XCTAssertEqual(c[clipPass], 5, "All five are free to grow")
        XCTAssertNil(c[clipFail], "Nothing on the Pass tier may clip")
    }

    func testTextClippingFail_everyTextIsClipped() throws {
        let c = try counts("AccessibleTextClippingFail", family: "textClipping")
        XCTAssertEqual(c[clipFail], 5, "All five are pinned, capped and truncated")
        XCTAssertNil(c[clipPass], "Nothing on the Fail tier may pass")
    }

    func testTextClippingPartial_reportsBothOutcomes() throws {
        let c = try counts("AccessibleTextClippingPartial", family: "textClipping")
        XCTAssertEqual(c[clipPass], 3, "Heading, body and total are all free to grow")
        XCTAssertEqual(c[clipFail], 2, "The promo strapline and the disclaimer are truncated")
    }

    // MARK: - The tiers isolate one defect each

    func testEachTierIsolatesItsOwnDefect() throws {
        for screen in ["AccessibleTextClippingPass", "AccessibleTextClippingFail",
                       "AccessibleTextClippingPartial"] {
            XCTAssertNil(try counts(screen, family: "textResize")[resizeFail],
                         "\(screen) is about clipping, but something fails to resize")
        }
        for screen in ["AccessibleTextResizePass", "AccessibleTextResizePartial"] {
            XCTAssertNil(try counts(screen, family: "textClipping")[clipFail],
                         "\(screen) is about resizing, but something is clipped")
        }
    }

    // MARK: - The regex that got this wrong once

    /// `.font(.system(size: 22))` was classified as scalable for a while, because the linter's
    /// pattern allowed `system(` and `Font.system(` but not the leading dot of `.system(` —
    /// the spelling everyone actually writes. Every fixed font fell through to the scalable
    /// branch and this whole Fail tier reported five passes.
    func testFixedSystemFontIsNotMistakenForAScalableOne() throws {
        let c = try counts("AccessibleTextResizeFail", family: "textResize")
        XCTAssertNil(c[resizePass],
                     "A .font(.system(size:)) must never be classified as scalable")
    }
}
