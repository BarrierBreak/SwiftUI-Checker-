//
//  FocusIndicatorContrastTests.swift
//
//  Focus indicator colour contrast, one test per tier. The scan is narrowed to the focus rules
//  (BB40117 "Insufficient color contrast for focus indicator", BB40119 "Color alone used to
//  indicate focus"), and the rows each Focus screen promises in its doc comment are counted.
//
//    Pass     3 rings, all easy to see and more than a colour          -> nothing
//    Fail     4 rings: light and grey 2pt (117), dark hairline (119),
//             light hairline (both)                                    -> 3 x BB40117, 2 x BB40119
//    Partial  2 sound rings, a light 2pt ring, a dark hairline         -> 1 x BB40117, 1 x BB40119
//
import XCTest

final class FocusIndicatorContrastTests: XCTestCase {

    private let contrast = "Insufficient color contrast for focus indicator"
    private let colourOnly = "Color alone used to indicate focus"

    /// How many rows of each title the screen's own source produced.
    private func counts(_ screen: String) throws -> [String: Int] {
        var result: [String: Int] = [:]
        for row in try runScan(screen: screen, family: "focus", includePasses: true) where row.element.contains("\(screen).swift:") {
            result[row.rule, default: 0] += 1
        }
        return result
    }

    private func assertCounts(_ screen: String, contrast expectedContrast: Int, colourOnly expectedColourOnly: Int,
                              file: StaticString = #filePath, line: UInt = #line) throws {
        let c = try counts(screen)
        XCTAssertEqual(c[contrast] ?? 0, expectedContrast, "\"\(contrast)\"\nall: \(c)", file: file, line: line)
        XCTAssertEqual(c[colourOnly] ?? 0, expectedColourOnly, "\"\(colourOnly)\"\nall: \(c)", file: file, line: line)
    }

    func testFocusIndicatorContrastPass() throws {
        try assertCounts("AccessibleFocusPass", contrast: 0, colourOnly: 0)
    }

    func testFocusIndicatorContrastFail() throws {
        try assertCounts("AccessibleFocusFail", contrast: 3, colourOnly: 2)
    }

    func testFocusIndicatorContrastPartial() throws {
        try assertCounts("AccessibleFocusPartial", contrast: 1, colourOnly: 1)
    }
}
