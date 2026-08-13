//
//  SwiftUIA11yScanRunner.swift
//  SwiftUIAccessibilityChecker
//
//  Runs the A11yInspect framework against every Accessible Name example screen
//  (Pass / Fail / Partial) and prints a structured summary: total elements
//  tested, total scans, total rulesets run, and per-screen issues broken down
//  by ruleset. Ported from the AccessibilityTestApp demo's scan-and-report
//  harness (SwiftUIA11yScanRunner.swift / SwiftUIDemoA11ySummaryReporter),
//  adapted to scan this project's 3 example screens via the framework's own
//  A11yInspector rather than a hand-rolled per-rule scanner.
//
//  Trigger: launch the app with the argument  --a11y-scan
//  Results: printed to the Xcode console AND written to
//           ~/Documents/a11y-demo-report.txt
//

import UIKit
import SwiftUI
import A11yInspect_Accessibility_Framework

private extension String {
    func leftPad(_ width: Int) -> String {
        let pad = width - count
        return pad > 0 ? String(repeating: " ", count: pad) + self : self
    }
}

// MARK: - Summary Reporter

public final class SwiftUIDemoA11ySummaryReporter {

    public static let shared = SwiftUIDemoA11ySummaryReporter()
    private init() {}

    private struct ScanRecord {
        let index: Int
        let screenName: String
        let screenClass: String
        let elementCount: Int
        let results: [AccessibilityTechniqueAnnotated]
        /// Element positions captured during the scan, keyed by record id. `elementInfo.view`
        /// is a weak reference, so by the time the report is formatted the screen has been
        /// swapped out and the view is gone — reading the frame then yields nothing. These
        /// are recorded while the view is still alive.
        let locations: [String: String]
    }

    private var scans: [ScanRecord] = []
    private let lock = NSLock()

    public func addScan(
        screenName: String,
        screenClass: String = "",
        elementCount: Int = 0,
        results: [AccessibilityTechniqueAnnotated],
        locations: [String: String] = [:]
    ) {
        lock.lock(); defer { lock.unlock() }
        scans.append(ScanRecord(
            index: scans.count + 1,
            screenName: screenName,
            screenClass: screenClass,
            elementCount: elementCount,
            results: results,
            locations: locations
        ))
    }

    /// Real class of the flagged element for the report — "UIButton" etc. for UIKit
    /// views, and a trait-derived name for SwiftUI elements (whose UIKit-level class
    /// is always the opaque "SwiftUI.Element" proxy). Replaces record.element, which
    /// is the rule's database *category* column ("Keyboard", "Forms") — misleading
    /// when read as the element's class.
    private func displayClass(_ info: AccessibilityElementInfo) -> String {
        guard info.className == "SwiftUI.Element" else { return info.className }
        let traits = UIAccessibilityTraits(rawValue: info.accessibilityTraits)
        // Toggles carry .button too, so this has to be tested first or every switch
        // displays as "SwiftUIButton". 1 << 53 is the toggle-button trait, which UIKit
        // does not expose to Swift.
        if info.accessibilityTraits & (1 << 53) != 0 { return "SwiftUIToggle" }
        if traits.contains(.button) { return "SwiftUIButton" }
        if traits.contains(.link) { return "SwiftUILink" }
        if traits.contains(.adjustable) { return "SwiftUIAdjustable" }
        if traits.contains(.header) { return "SwiftUIHeading" }
        if traits.contains(.image) { return "SwiftUIImage" }
        if traits.contains(.staticText) { return "SwiftUIText" }
        return "SwiftUIElement"
    }

    /// Source line of the control that produced this finding.
    ///
    /// There is no runtime link from a live view back to the code that declared it, so the
    /// screens record it themselves: each control carries `accessibilityIdentifier`
    /// "src:<line>", written with `#line` at its declaration. This reads that back.
    private func elementLocation(_ info: AccessibilityElementInfo, captured: String? = nil) -> String {
        if let captured, !captured.isEmpty { return captured }
        guard let id = info.accessibilityIdentifier, id.hasPrefix("src:") else { return "" }
        return String(id.dropFirst(4))
    }

    private func elementName(_ info: AccessibilityElementInfo) -> String {
        let label = info.accessibilityLabel?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return (label.isEmpty || label == "None") ? "no name" : label
    }

    public func reset() {
        lock.lock(); defer { lock.unlock() }
        scans = []
    }

    private func severity(for rule: String) -> String {
        let r = rule.lowercased()
        let high = ["target size", "missing accessib", "adjustable element missing", "ambiguous"]
        let medium = ["image", "heading", "orientation", "generic and does not convey", "restates the element role", "anti-pattern"]
        if high.contains(where: { r.contains($0) }) { return "High" }
        if medium.contains(where: { r.contains($0) }) { return "Medium" }
        return "Low"
    }

    private func category(for rule: String) -> String {
        let r = rule.lowercased()
        if r.contains("hint") { return "Hint Issues" }
        if r.contains("value") { return "Value Issues" }
        if r.contains("label") || r.contains("name") || r.contains("description") || r.contains("heading") { return "Label Issues" }
        if r.contains("target") || r.contains("size") || r.contains("spacing") { return "Touch Target Issues" }
        if r.contains("trait") || r.contains("role") || r.contains("ambiguous") { return "Trait Issues" }
        if r.contains("orientation") { return "Orientation Issues" }
        if r.contains("link") { return "Link Issues" }
        return "Other Issues"
    }

    private func perScanSection() -> String {
        var lines: [String] = []
        lines.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        lines.append("  PER-SCREEN SCAN RESULTS")
        lines.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        for scan in scans {
            let failures = scan.results.filter { $0.record.status.lowercased() == "fail" }
            lines.append("\nScan \(scan.index):")
            lines.append("  Screen          : \(scan.screenName)")
            lines.append("  Screen Class    : \(scan.screenClass)")
            lines.append("  Elements Tested : \(scan.elementCount)")
            let failsByRule = Dictionary(grouping: failures) { $0.record.issueVariable }
            // Element count per issue, so a screen can be checked against what is actually
            // on it without reading the whole list: "13 across 3 rules — 8, 4, 1 elements".
            let perRuleCounts = failsByRule.keys.sorted().map { failsByRule[$0]!.count }
            let ruleWord = failsByRule.count == 1 ? "rule" : "rules"
            lines.append("  Issues          : \(failures.count)"
                + (failsByRule.isEmpty ? "" : " across \(failsByRule.count) \(ruleWord) — "
                    + perRuleCounts.map(String.init).joined(separator: ", ") + " elements"))
            if !failsByRule.isEmpty {
                lines.append("  Issues by rule:")
                for rule in failsByRule.keys.sorted() {
                    let group = failsByRule[rule]!
                    lines.append("    - \(rule) — \(group.count) element\(group.count == 1 ? "" : "s")")
                    lines.append("      Affected Elements:")
                    for result in group {
                        let cls = displayClass(result.elementInfo)
                        let name = elementName(result.elementInfo)
                        let where_ = elementLocation(result.elementInfo, captured: scan.locations[result.id])
                        lines.append("        • \(cls) [\(name)]\(where_.isEmpty ? "" : " — \(where_)") — Screen: \(scan.screenClass)")
                    }
                }
            }
        }
        return lines.joined(separator: "\n")
    }

    public func formatted() -> String {
        lock.lock(); defer { lock.unlock() }

        // Screen shown as "Name (ScreenClass)" so every issue carries the full class
        // of the screen it was found on, e.g. "Pass (AccessibleNamePass)".
        let allWithScreen: [(screen: String, result: AccessibilityTechniqueAnnotated)] =
            scans.flatMap { scan in
                let label = scan.screenClass.isEmpty ? scan.screenName : "\(scan.screenName) (\(scan.screenClass))"
                return scan.results.map { (label, $0) }
            }
        let allResults = allWithScreen.map { $0.result }
        let locationsByID = scans.reduce(into: [String: String]()) { $0.merge($1.locations) { a, _ in a } }
        let totalElements = scans.reduce(0) { $0 + $1.elementCount }

        let allByRule  = Dictionary(grouping: allWithScreen) { $0.result.record.issueVariable }
        let allRuleIDs = allByRule.keys.sorted()

        let allFails    = allResults.filter { $0.record.status.lowercased() == "fail" }
        let allPasses   = allResults.filter { $0.record.status.lowercased() == "pass" }
        let allWarnings = allResults.filter {
            let s = $0.record.status.lowercased()
            return s == "validate" || s == "suggestion"
        }

        var out: [String] = []

        // ── Section 1: Global Summary ───────────────────────────────
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        out.append("  1. GLOBAL SUMMARY")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        out.append("  Total Screens Scanned  : \(scans.count)")
        out.append("  Total Elements Tested  : \(totalElements)")
        out.append("  Total Rules Executed   : \(allRuleIDs.count)")
        out.append("  Total Failures         : \(allFails.count)")
        out.append("  Total Warnings         : \(allWarnings.count)")
        out.append("  Total Passes           : \(allPasses.count)")
        out.append("  UIKit Failures         : 0")
        out.append("  SwiftUI Failures       : \(allFails.count)")
        let emoji = allFails.isEmpty ? "✅" : "❌"
        out.append("  \(emoji) Overall Status        : \(allFails.isEmpty ? "PASS" : "FAIL")")

        // ── Section 2: Per-Screen Results ───────────────────────────
        out.append("")
        out.append(perScanSection())

        // ── Section 2: Ruleset-Wise Failure Report ──────────────────
        out.append("")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        out.append("  2. RULESET-WISE FAILURE REPORT")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        for rule in allRuleIDs {
            let entries = allByRule[rule] ?? []
            let fails   = entries.filter { $0.result.record.status.lowercased() == "fail" }
            let passes  = entries.filter { $0.result.record.status.lowercased() == "pass" }
            let warns   = entries.filter {
                let s = $0.result.record.status.lowercased(); return s == "validate" || s == "suggestion"
            }

            out.append("")
            out.append("Rule: \(rule)")
            out.append("  UIKit Failures   : 0")
            out.append("  SwiftUI Failures : \(fails.count)")
            out.append("  Total Failures   : \(fails.count)")
            out.append("  Warnings         : \(warns.count)")
            out.append("  Passes           : \(passes.count)")
            out.append("  Severity         : \(severity(for: rule))")
            if !fails.isEmpty {
                let byClass = Dictionary(grouping: fails) { displayClass($0.result.elementInfo) }
                out.append("  Issue Breakdown:")
                for cls in byClass.keys.sorted() {
                    out.append("    - \(cls): \(byClass[cls]!.count)")
                }
                out.append("  Affected Elements ( \(fails.count)):")
                for entry in fails {
                    let cls = displayClass(entry.result.elementInfo)
                    let name = elementName(entry.result.elementInfo)
                    let where_ = elementLocation(entry.result.elementInfo, captured: locationsByID[entry.result.id])
                    out.append("    • \(cls) [\(name)]\(where_.isEmpty ? "" : " — \(where_)") — Screen: \(entry.screen)")
                }
                if let fix = fails.first?.result.record.recommendation, !fix.isEmpty {
                    out.append("  Suggested Fix    : \(fix)")
                }
            }
            out.append("  ──────────────────────────────────────────────")
        }

        // ── Section 3: Complete Issue List ──────────────────────────
        out.append("")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        out.append("  3. COMPLETE ISSUE LIST")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        let allIssues = allWithScreen.filter {
            let s = $0.result.record.status.lowercased()
            return s == "fail" || s == "validate" || s == "suggestion"
        }
        if allIssues.isEmpty {
            out.append("  ✅ No issues found.")
        } else {
            for (i, entry) in allIssues.enumerated() {
                let r = entry.result
                out.append("")
                out.append("  \(i + 1). [\(r.record.status.uppercased())] \(r.record.issueVariable)")
                out.append("       Screen     : \(entry.screen)")
                out.append("       Class      : \(displayClass(r.elementInfo))")
                let loc = elementLocation(r.elementInfo, captured: locationsByID[r.id])
                out.append("       Element    : \(elementName(r.elementInfo))\(loc.isEmpty ? "" : " — \(loc)")")
                out.append("       Detail     : \(r.record.attribute)")
            }
        }

        // ── Section 4: Rule Failure Summary Table ───────────────────
        out.append("")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        out.append("  4. RULE FAILURE SUMMARY TABLE")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        let colW = 34
        let header = "  " + "Rule Name".padding(toLength: colW, withPad: " ", startingAt: 0)
                   + " UIKit Fail SwiftUI Fail      Total  Severity"
        out.append(header)
        out.append("  " + String(repeating: "-", count: 78))
        for rule in allRuleIDs {
            let entries = allByRule[rule] ?? []
            let fails   = entries.filter { $0.result.record.status.lowercased() == "fail" }
            let name    = rule.count > colW ? String(rule.prefix(colW - 1)) + "…" : rule
            let paddedName = name.padding(toLength: colW, withPad: " ", startingAt: 0)
            let sev = severity(for: rule)
            out.append("  \(paddedName) \(String(0).leftPad(10)) \(String(fails.count).leftPad(12)) \(String(fails.count).leftPad(10)) \(sev.leftPad(9))")
        }

        // ── Section 5: Top Failure Rulesets ─────────────────────────
        out.append("")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        out.append("  5. TOP FAILURE RULESETS")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        let ranked = allRuleIDs
            .map { rule -> (String, Int) in
                let f = (allByRule[rule] ?? []).filter { $0.result.record.status.lowercased() == "fail" }.count
                return (rule, f)
            }
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
            .prefix(5)
        if ranked.isEmpty {
            out.append("  ✅ No failures detected across any ruleset.")
        } else {
            for (i, entry) in ranked.enumerated() {
                out.append("  \(i + 1). \(entry.0) → \(entry.1) failure\(entry.1 == 1 ? "" : "s")")
            }
        }

        // ── Section 6: Issue Category Summary ───────────────────────
        out.append("")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        out.append("  6. ISSUE CATEGORY SUMMARY")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        var cats: [String: Int] = [:]
        for fail in allFails {
            let cat = category(for: fail.record.issueVariable)
            cats[cat, default: 0] += 1
        }
        if cats.isEmpty {
            out.append("  ✅ No failures to categorise.")
        } else {
            for cat in cats.keys.sorted() {
                out.append("  \(cat) → \(cats[cat]!)")
            }
        }

        // ── Section 7: JSON Output ───────────────────────────────────
        out.append("")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        out.append("  7. JSON SUMMARY")
        out.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        var jsonRules: [[String: Any]] = []
        for rule in allRuleIDs {
            let entries = allByRule[rule] ?? []
            let fails   = entries.filter { $0.result.record.status.lowercased() == "fail" }
            let byClass = Dictionary(grouping: fails) { displayClass($0.result.elementInfo) }.mapValues { $0.count }
            let affectedElements = fails.map { entry -> [String: String] in
                [
                    "screen": entry.screen,
                    "class": displayClass(entry.result.elementInfo),
                    "element": elementName(entry.result.elementInfo),
                    "detail": entry.result.record.attribute
                ]
            }
            jsonRules.append([
                "rule": rule,
                "uikit_failures": 0,
                "swiftui_failures": fails.count,
                "total": fails.count,
                "severity": severity(for: rule),
                "issues": byClass,
                "affected_elements": affectedElements
            ])
        }
        let allIssuesJSON = allWithScreen
            .filter {
                let s = $0.result.record.status.lowercased()
                return s == "fail" || s == "validate" || s == "suggestion"
            }
            .map { entry -> [String: String] in
                [
                    "screen": entry.screen,
                    "rule": entry.result.record.issueVariable,
                    "status": entry.result.record.status,
                    "class": displayClass(entry.result.elementInfo),
                    "element": elementName(entry.result.elementInfo),
                    "detail": entry.result.record.attribute
                ]
            }
        let jsonObj: [String: Any] = [
            "total_screens": scans.count,
            "total_elements": totalElements,
            "all_issues": allIssuesJSON,
            "total_rules": allRuleIDs.count,
            "total_failures": allFails.count,
            "total_warnings": allWarnings.count,
            "total_passes": allPasses.count,
            "uikit_failures": 0,
            "swiftui_failures": allFails.count,
            "rules": jsonRules
        ]
        if let data = try? JSONSerialization.data(withJSONObject: jsonObj, options: [.prettyPrinted, .sortedKeys]),
           let jsonStr = String(data: data, encoding: .utf8) {
            out.append(jsonStr)
        }

        return out.joined(separator: "\n")
    }

    public func writeSummary() {
        guard !scans.isEmpty else { return }
        let output = formatted()
        print("\n\(output)\n")

        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let url = docsDir?.appendingPathComponent("a11y-demo-report.txt") {
            try? output.write(to: url, atomically: true, encoding: .utf8)
            print("[A11yDemo] Report saved → \(url.path)")
        }

        // Signal completion via a hidden accessibility element so a UI test can
        // wait for and read the report without needing pasteboard access.
        let reportForTest = output
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else { return }

            let signal = UILabel()
            signal.text = "ScanDone"
            signal.accessibilityIdentifier = "a11yScanDone"
            signal.accessibilityValue = reportForTest
            signal.isAccessibilityElement = true
            signal.alpha = 0.01
            signal.frame = CGRect(x: -1, y: -1, width: 1, height: 1)
            window.addSubview(signal)
        }
    }
}

// MARK: - Screen Catalogue

private struct SwiftUIScreenEntry {
    let name: String
    let className: String
    let make: () -> AnyView
}

private func entry<V: View>(_ name: String, _ makeView: @autoclosure @escaping () -> V) -> SwiftUIScreenEntry {
    SwiftUIScreenEntry(name: name, className: String(describing: V.self)) { AnyView(makeView()) }
}

private func allSwiftUIScreenEntries() -> [SwiftUIScreenEntry] {
    [
        entry("Pass", AccessibleNamePass()),
        entry("Fail", AccessibleNameFail()),
        entry("Partial", AccessibleNamePartial()),
        entry("Extras Pass", AccessibleNameExtrasPass()),
        entry("Extras Fail", AccessibleNameExtrasFail()),
        entry("Extras Partial", AccessibleNameExtrasPartial()),

        // The Native Role and Role screens are scanned by the role rulesets, not the
        // accessible-name one this runner reports on, so they are deliberately not listed:
        //   AccessibleNativeRolePass / Fail / Partial
        //   AccessibleRolePass / Fail / Partial
    ]
}

// MARK: - Runner

@MainActor
public final class SwiftUIA11yScanRunner {

    public static let shared = SwiftUIA11yScanRunner()
    private init() {}

    private var hasRun = false

    /// Finds the nearest scrollable content view (Form/List are UIScrollView-backed)
    /// so lazily-instantiated rows below the fold can be scrolled into view and scanned.
    private func findScrollView(in view: UIView) -> UIScrollView? {
        var queue = view.subviews
        while !queue.isEmpty {
            let current = queue.removeFirst()
            if let sv = current as? UIScrollView, sv.isScrollEnabled { return sv }
            queue.append(contentsOf: current.subviews)
        }
        return nil
    }

    /// Content-space key so the same physical row scanned from two overlapping scroll
    /// positions collapses to one entry instead of being reported/counted twice.
    /// Falls back to label+class for UIKit elements, which don't have a content frame.
    /// `Int(_:)` traps on a non-finite or out-of-range Double, and an accessibility frame
    /// is not guaranteed finite — an element that has not been laid out reports
    /// `CGRect.null`, whose origin is infinity. Collapse those to a placeholder instead.
    private func component(_ value: CGFloat) -> String {
        guard value.isFinite, value > -1_000_000_000, value < 1_000_000_000 else { return "~" }
        return String(Int(value.rounded()))
    }

    private func rectKey(_ rect: CGRect) -> String {
        "\(component(rect.origin.x))|\(component(rect.origin.y))|\(component(rect.size.width))|\(component(rect.size.height))"
    }

    /// Source line of the control, if it tagged itself. A far stronger identity than
    /// position: a control keeps its line no matter where it is laid out.
    private func sourceLine(_ info: AccessibilityElementInfo) -> String? {
        if let id = info.accessibilityIdentifier, id.hasPrefix("src:") { return String(id.dropFirst(4)) }
        if let id = info.view?.accessibilityIdentifier, id.hasPrefix("src:") { return String(id.dropFirst(4)) }
        return nil
    }

    private func dedupKey(for item: AccessibilityTechniqueAnnotated, scrollView: UIScrollView?) -> String {
        let info = item.elementInfo

        // Prefer the source line. Position alone is unreliable: a Form re-lays-out as it
        // scrolls, so one control measured in two captures lands at two different y values
        // and survives as two findings — the TextField on the Partial screen was reported
        // twice from line 94, and the TextEditor twice from line 150.
        //
        // x/width/height are kept but y is deliberately excluded: that is exactly the
        // component that drifts. Controls built in a loop (the five rating stars, all
        // declared on one line) sit side by side, so their differing x keeps them apart.
        if let line = sourceLine(info) {
            // Only x is kept from the frame. y drifts when the scroll view re-lays-out,
            // and width/height drift too — the TextEditor on the Fail screen reported a
            // 338×100 frame in one capture and 338×5 in another, so including size split
            // one control into two findings. x is stable and is what separates controls
            // built side by side in a loop (the rating stars share a line but not an x).
            // x is bucketed rather than exact. It is here only to separate controls built
            // side by side in a loop (the rating stars share a source line but sit ~30pt
            // apart); an exact value also split ONE control across captures when its x
            // drifted by a few points during layout — the TextEditor on the Partial screen
            // reported line 108 twice. A 20pt bucket keeps loop siblings apart while
            // absorbing that drift.
            let rect = info.swiftUIContentFrame ?? info.swiftUIFrame ?? info.view?.frame
            let column = rect.map { r -> String in
                guard r.origin.x.isFinite else { return "~" }
                return String(Int((r.origin.x / 20).rounded()))
            } ?? ""
            return "\(item.record.techniqueID)|src:\(line)|\(info.accessibilityLabel ?? "")|\(column)"
        }

        // SwiftUI elements carry a scroll-invariant content frame captured at collection
        // time — position uniquely identifies the element regardless of scroll offset.
        if let cf = info.swiftUIContentFrame, cf != .zero {
            return "\(item.record.techniqueID)|\(rectKey(cf))"
        }

        // UIKit views: AccessibilityElementInfo(view:) never populates the SwiftUI frame
        // fields, so findings from the UIKit path used to fall through to a key built only
        // from techniqueID + class + label. Two identical unnamed controls (e.g. two
        // image-only UIButtons, or two buttons both titled "More") produced byte-identical
        // keys, so every one after the first was silently discarded as a duplicate.
        // Derive a position from the view instead — converted into the scroll view's
        // content space so it stays stable across scroll positions.
        if let view = info.view {
            let frame = scrollView.map { $0.convert(view.bounds, from: view) } ?? view.frame
            return "\(item.record.techniqueID)|\(info.className)|\(rectKey(frame))"
        }

        return "\(item.record.techniqueID)|\(info.className)|\(info.accessibilityLabel ?? "")"
    }

    /// "Elements Tested" counts interactive controls only — buttons, links, adjustable
    /// controls, and trait-less input elements (text fields/editors, pickers). Section
    /// titles, static text, headings, and plain images are VoiceOver stops but not
    /// controls, so they're excluded from the count.
    private func isInteractiveControl(_ el: SwiftUIAccessibilityElement) -> Bool {
        if el.isInteractive { return true }
        if el.isStaticText || el.isHeading || el.isImage { return false }
        return true
    }

    private func elementKey(_ el: SwiftUIAccessibilityElement) -> String {
        // Same identity the findings use, so "Elements Tested" and the number of reported
        // elements agree. Keying on position alone counted one control twice whenever the
        // Form re-laid-out between captures and moved it: the Pass screen reported 24
        // elements for 19 real controls, with Username, Password, Share this page, Open
        // settings and Delete account each counted twice.
        if let id = el.identifier, id.hasPrefix("src:") {
            let column = el.contentFrame.map { component($0.origin.x) } ?? ""
            return "\(id)|\(el.label ?? "")|\(column)"
        }
        if let cf = el.contentFrame, cf != .zero {
            return rectKey(cf)
        }
        return "\(el.label ?? "")|\(el.frame)"
    }

    /// SwiftUI backs several of its controls with real UIKit views — a `Menu`, `ShareLink`
    /// or a plain `Button` inside a Form row resolves to a `UIButton` underneath. That one
    /// control is therefore visible to both scan paths and gets reported twice for the same
    /// rule: once as the SwiftUI element and once as the backing view. (On the Pass screen
    /// "Save Draft" appeared as both `SwiftUIButton` and `UIButton`; on Fail an unnamed
    /// button did the same.) Where a UIKit-path finding sits on top of a SwiftUI-path
    /// finding for the same rule, the SwiftUI record is the one describing the control the
    /// developer actually wrote, so the backing-view record is dropped.
    private func removingBackingViewDuplicates(
        _ results: [AccessibilityTechniqueAnnotated],
        scrollView: UIScrollView?
    ) -> [AccessibilityTechniqueAnnotated] {
        var swiftUIRectsByRule: [String: [CGRect]] = [:]
        var swiftUINamesByRule: [String: Set<String>] = [:]
        for item in results {
            guard let cf = item.elementInfo.swiftUIContentFrame, cf != .zero else { continue }
            swiftUIRectsByRule[item.record.techniqueID, default: []].append(cf)
            let name = (item.elementInfo.accessibilityLabel ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            swiftUINamesByRule[item.record.techniqueID, default: []].insert(name)
        }
        guard !swiftUIRectsByRule.isEmpty else { return results }

        return results.filter { item in
            // SwiftUI-path records are always kept.
            if let cf = item.elementInfo.swiftUIContentFrame, cf != .zero { return true }

            let ruleID = item.record.techniqueID
            // No SwiftUI record for this rule means the UIKit path is the only thing that
            // detected it — keep it. That is how the image-button and hint-instead-of-label
            // findings survive: the SwiftUI path cannot produce them at all.
            guard let candidates = swiftUIRectsByRule[ruleID] else { return true }

            if let view = item.elementInfo.view {
                let frame = scrollView.map { $0.convert(view.bounds, from: view) } ?? view.frame
                let area = frame.width * frame.height
                if area > 0 {
                    // Majority overlap only — a screen-sized container that merely
                    // *contains* a flagged SwiftUI element must not be mistaken for it.
                    let overlapsSwiftUIElement = candidates.contains { candidate in
                        let overlap = candidate.intersection(frame)
                        guard !overlap.isNull else { return false }
                        return overlap.width * overlap.height >= area * 0.5
                    }
                    if overlapsSwiftUIElement { return false }
                }
            }

            // Geometry does not always line up — SwiftUI's backing view can be laid out at
            // a different size than the accessibility element it feeds. Fall back to the
            // name: same rule plus same accessible name on the same screen is the same
            // finding, already reported by the SwiftUI record.
            let name = (item.elementInfo.accessibilityLabel ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            return !(swiftUINamesByRule[ruleID]?.contains(name) ?? false)
        }
    }

    /// Drops the "verify the name is descriptive" record from any control whose accessible
    /// name is reported as a duplicate somewhere on the same screen.
    ///
    /// The framework evaluates the duplicate check against whatever is rendered in the
    /// *current viewport*. A Form renders lazily, so when two controls sharing a name are
    /// far apart only one is laid out at a time: in that capture the control looks unique
    /// and gets BB40002 ("verify if the accessible name is descriptive"), and in a later
    /// capture — once both are laid out — it correctly gets the BB40090 duplicate Fail.
    /// The same element therefore ends up under two rules. Observed on the Fail screen:
    /// "Bin" at content frame (16, 514) carried a BB40002 row from the first capture and a
    /// BB40090 row from the capture at offset 1367. The duplicate Fail is the accurate
    /// finding, so the descriptiveness row for that name is removed.
    private func droppingDescriptivenessForDuplicateNames(
        _ results: [AccessibilityTechniqueAnnotated]
    ) -> [AccessibilityTechniqueAnnotated] {
        func name(_ item: AccessibilityTechniqueAnnotated) -> String {
            (item.elementInfo.accessibilityLabel ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let duplicatedNames = Set(
            results.filter { $0.record.techniqueID == "BB40090" }.map(name)
        ).subtracting([""])

        // Same idea for the label-in-name Fail: a button whose accessible name does not
        // match its visible label has already been judged on its name, so the "verify the
        // name is descriptive" Validate is a second row for one problem. Keyed on source
        // line, since it is the same control both times — "Submit form" on the UIKit Fail
        // screen carried both.
        let linesWithNameFail = Set(
            results.filter { $0.record.techniqueID == "BB40088" }
                   .compactMap { sourceLine($0.elementInfo) }
        )

        guard !duplicatedNames.isEmpty || !linesWithNameFail.isEmpty else { return results }

        return results.filter { item in
            guard item.record.techniqueID == "BB40002" || item.record.techniqueID == "BB40540" else { return true }
            if duplicatedNames.contains(name(item)) { return false }
            if let line = sourceLine(item.elementInfo), linesWithNameFail.contains(line) { return false }
            return true
        }
    }

    /// Drops the general "Missing accessible name for button" record when a more specific
    /// rule already describes the same control.
    ///
    /// The two findings come from different workflows — the SwiftUI path reports the
    /// generic missing name, while the UIKit path recognises *why* it is missing (an image
    /// with no description, or a hint used instead of a label). Both fired on one control,
    /// which read as a duplicate: line 51 appeared under both "Missing accessible name for
    /// button" and "Missing accessible name for image button", and line 56 under both that
    /// and "Incorrect method used to provide accessible name for Button". The specific
    /// diagnosis is the more useful one, so the general row is removed.
    private func droppingGeneralWhenSpecificExists(
        _ results: [AccessibilityTechniqueAnnotated]
    ) -> [AccessibilityTechniqueAnnotated] {
        let specificRules: Set<String> = ["BB40004", "BB40049"]
        let linesWithSpecificFinding = Set(
            results.filter { specificRules.contains($0.record.techniqueID) }
                   .compactMap { sourceLine($0.elementInfo) }
        )
        guard !linesWithSpecificFinding.isEmpty else { return results }

        return results.filter { item in
            guard item.record.techniqueID == "BB40003" else { return true }
            guard let line = sourceLine(item.elementInfo) else { return true }
            return !linesWithSpecificFinding.contains(line)
        }
    }

    /// Keeps one control in one rule family. If a source line is reported by a Button rule,
    /// any interactive-control rule row for that same line is dropped.
    ///
    /// One control can legitimately look like both to the two scan paths. On the Fail
    /// screen line 69 is `UIKitButton(title: "Archive", clearButtonTrait: true)`: the
    /// SwiftUI path sees the stripped .button trait and files it under the control rule,
    /// while the UIKit path sees a real UIButton and files it under the Button rule. Both
    /// readings are defensible on their own, but the element is a button — so the Button
    /// row is the one that stays.
    private func keepingButtonFamilyForButtons(
        _ results: [AccessibilityTechniqueAnnotated]
    ) -> [AccessibilityTechniqueAnnotated] {
        let buttonRules: Set<String> = ["BB40002", "BB40540", "BB40003", "BB40004", "BB40049", "BB40088"]
        let controlRules: Set<String> = ["BB30548", "BB30549", "BB40051", "BB40124", "BB40125"]

        let linesReportedAsButton = Set(
            results.filter { buttonRules.contains($0.record.techniqueID) }
                   .compactMap { sourceLine($0.elementInfo) }
        )
        guard !linesReportedAsButton.isEmpty else { return results }

        return results.filter { item in
            guard controlRules.contains(item.record.techniqueID),
                  let line = sourceLine(item.elementInfo) else { return true }
            return !linesReportedAsButton.contains(line)
        }
    }

    /// "Headings not defined" is a statement about the SCREEN, not about one element, so
    /// it belongs in the report once. The workflow has to attach it to some element to be
    /// reportable, and each capture picks a different one — the Fail screen produced four
    /// rows pointing at four unrelated controls. Keep the first and drop the rest.
    private func collapsingScreenLevelFindings(
        _ results: [AccessibilityTechniqueAnnotated]
    ) -> [AccessibilityTechniqueAnnotated] {
        let screenLevelRules: Set<String> = ["BB41008"]
        var alreadyReported = Set<String>()
        return results.filter { item in
            guard screenLevelRules.contains(item.record.techniqueID) else { return true }
            return alreadyReported.insert(item.record.techniqueID).inserted
        }
    }

    /// Collapses repeated VALIDATE / SUGGESTION rows that print identically in the report.
    ///
    /// A screen is scanned once per scroll position, and a SwiftUI Form re-lays-out as it
    /// scrolls, so one control can be measured at two different content-space positions and
    /// survive the position-based dedup twice — the same "Verify if accessible name for
    /// button is descriptive / Open settings" line appearing twice.
    ///
    /// Only manual-review rows are collapsed, on the exact fields the report prints (rule,
    /// class, element name, detail). If two of those rows are identical there is nothing to
    /// tell them apart on screen, so keeping both only adds noise. FAIL and PASS rows are
    /// left untouched: repeats there are real and countable — three unnamed buttons should
    /// stay three findings even though all three print as "no name".
    private func collapsingRepeatedValidateRows(
        _ results: [AccessibilityTechniqueAnnotated]
    ) -> [AccessibilityTechniqueAnnotated] {
        var seenValidateRows = Set<String>()
        return results.filter { item in
            let status = item.record.status.lowercased()
            guard status == "validate" || status == "suggestion" else { return true }

            let info = item.elementInfo
            let row = [
                item.record.techniqueID,
                item.record.issueVariable,
                info.className,
                String(info.accessibilityTraits),
                info.accessibilityLabel ?? "",
                item.record.attribute
            ].joined(separator: "|")
            return seenValidateRows.insert(row).inserted
        }
    }

    /// The 12 accessible-name rules from the ruleset sheet — the only rules this demo
    /// reports. Everything else the workflows emit (heading checks, image-label checks,
    /// "button does not require interaction", "text missing role button", "needs to be
    /// hidden", "inaccurate description", …) is filtered out.
    private let allowedTechniqueIDs: Set<String> = [
        
        // For Name
        
        "BB40002", "BB40540",   // Verify if accessible name for button is descriptive (UIKit + SwiftUI)
        "BB40003",              // Missing accessible name for button (UIButton only)
        "BB40042",              // Text functions as a link but is missing role link

        // For role — Button
        // For role — Heading
        "BB40040",              // Check if Provided headings should be marked as heading
        "BB40041",              // Check whether the text should be a heading
//        "BB41008",              // Headings not defined — disabled, see HeadingQualityWorkflow

        "BB40001",              // Verify if button does not require interaction
        "BB40043",              // Text functions as a button but is missing role button
        "BB41004",              // Missing role for button
        "BB40004",              // Missing accessible name for image button
        "BB40049",              // Incorrect method used to provide accessible name for Button
        "BB40088",              // Accessible name for button and its visual label don't match
        "BB40090",              // Interactive elements have identical accessible name
        "BB30548",              // Missing accessible name for interactive control
        "BB30549",              // Incorrect method used to provide accessible name for interactive control
        "BB40124",              // Non-descriptive accessible name for interactive control
        "BB40051",              // Check if interactive control name is descriptive
        // Composite controls whose children are the accessibility elements — a compact
        // DatePicker is the case that matters here. SwiftUI builds their inner elements
        // only when an assistive client focuses them, so an in-process scan sees nothing
        // to check and the control would drop out of the report entirely. The framework
        // does still see the backing view and raises this manual-check row against it,
        // carrying the control's name and source line, so nothing goes unreported.
        "BB40546",              // Check if interactive controls needs to be hidden from screen reader user
        
      //  For role
        
    ]

    /// Reads the source line an element recorded on itself, at scan time. Captured here
    /// rather than in the reporter because `elementInfo.view` is weak — by the time the
    /// summary is written the screen has been torn down and the view is gone.
    private func capturedLocation(for item: AccessibilityTechniqueAnnotated, scrollView: UIScrollView?) -> String {
        if let id = item.elementInfo.accessibilityIdentifier, id.hasPrefix("src:") {
            return String(id.dropFirst(4))
        }
        if let id = item.elementInfo.view?.accessibilityIdentifier, id.hasPrefix("src:") {
            return String(id.dropFirst(4))
        }
        return ""
    }

    /// Reports composite UIKit controls that neither scan path can otherwise see.
    ///
    /// A compact `DatePicker` is the case this exists for. SwiftUI builds its inner
    /// accessibility elements only when an assistive client focuses them, so the SwiftUI
    /// walk finds nothing but the row's title text. The UIKit walk cannot reach it either:
    /// `getAllElements` bails out as soon as the root view's class starts with "_", and on
    /// a SwiftUI screen the root IS `_UIHostingView` — so that traversal returns empty
    /// before it starts. The control then vanishes from the report entirely.
    ///
    /// The backing view does exist, and it carries the label and source line the developer
    /// set. Running the workflow with that view as the root — its own class has no
    /// underscore — lets the framework raise its manual-check row against it, so the
    /// control is at least surfaced for a human to verify rather than silently dropped.
    private func findingsForUnreachableCompositeControls(in root: UIView) -> [AccessibilityTechniqueAnnotated] {
        var composites: [UIView] = []
        func walk(_ view: UIView) {
            if view.isHidden || view.alpha < 0.01 { return }
            // Only controls that are themselves invisible to VoiceOver because their
            // children carry the accessibility, and only ones the developer named.
            let isComposite = view is UIDatePicker || view is UIColorWell || view is UIPickerView
            if isComposite, !view.isAccessibilityElement, view.accessibilityLabel?.isEmpty == false {
                composites.append(view)
            }
            for sub in view.subviews { walk(sub) }
        }
        walk(root)
        guard !composites.isEmpty else { return [] }

        var found: [AccessibilityTechniqueAnnotated] = []
        for control in composites {
            let workflow = SufficientElementDescriptionWorkFlow()
            workflow.validateAllElements(in: control)
            found += workflow.matchedTechniqueRecords.filter { allowedTechniqueIDs.contains($0.record.techniqueID) }
        }
        return found
    }

    private func runWorkflows(on view: UIView) -> [AccessibilityTechniqueAnnotated] {
        let nameQualityWorkflow = ElementNameQualityWorkflow()
        nameQualityWorkflow.validateAllElements(in: view)

        let sufficientDescriptionWorkflow = SufficientElementDescriptionWorkFlow()
        sufficientDescriptionWorkflow.validateAllElements(in: view)

        let buttonWorkflow = UIButtonAccessibilityWorkflow()
        buttonWorkflow.validateAllButtons(in: view)

        let labelInNameWorkflow = LabelInNameWorkflow()
        labelInNameWorkflow.validateAllElements(in: view)

        let traitsWorkflow = AccessibilityTraitsWorkflow()
        traitsWorkflow.validateAllElements(in: view)

        // Heading role rules (BB40040 / BB40041 / BB41008) live in their own workflow,
        // which was not being driven at all — the runner only ran the five name-related
        // ones, so nothing heading-related could ever appear in the report.
        let headingWorkflow = HeadingQualityWorkflow()
        headingWorkflow.validateAllElements(in: view)

        let combined = nameQualityWorkflow.matchedTechniqueRecords
            + sufficientDescriptionWorkflow.matchedTechniqueRecords
            + buttonWorkflow.matchedTechniqueRecords
            + labelInNameWorkflow.matchedTechniqueRecords
            + traitsWorkflow.matchedTechniqueRecords
            + headingWorkflow.matchedTechniqueRecords

        return combined.filter { allowedTechniqueIDs.contains($0.record.techniqueID) }
            + findingsForUnreachableCompositeControls(in: view)
    }

    /// Swaps the key window's root view controller through every example screen
    /// (wrapped in a `UIHostingController`), scans each via the framework's own
    /// `A11yInspector`, then restores the original root and writes the combined
    /// summary. Idempotent — later calls are no-ops.
    public func runAllScreens() async {
        guard !hasRun else { return }
        hasRun = true

        print("[A11yDemo] Starting full SwiftUI accessible-name example scan…")

        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            print("[A11yDemo] ⚠️ No key window found — aborting scan.")
            return
        }

        let originalRootVC = window.rootViewController
        let reporter = SwiftUIDemoA11ySummaryReporter.shared
        reporter.reset()

        for entry in allSwiftUIScreenEntries() {
            let hostingController = UIHostingController(rootView: entry.make())
            hostingController.view.frame = window.bounds
            window.rootViewController = hostingController
            window.layoutIfNeeded()

            // Let SwiftUI finish its layout/render pass and publish its
            // accessibility tree before we walk it.
            try? await Task.sleep(nanoseconds: 300_000_000)
            window.layoutIfNeeded()

            var combinedResults: [AccessibilityTechniqueAnnotated] = []
            var seenResultKeys = Set<String>()
            var seenElementKeys = Set<String>()
            var capturedLocations: [String: String] = [:]

            // Resolved once up front so the very first capture can already key UIKit
            // findings by scroll-invariant position (see dedupKey).
            let scrollView = findScrollView(in: hostingController.view)

            func captureCurrentViewport() async {
                window.layoutIfNeeded()
                try? await Task.sleep(nanoseconds: 200_000_000)
                window.layoutIfNeeded()

                // The framework caches the element walk per hosting view for 10s so the
                // workflows share one traversal — but every scroll position here changes
                // which rows exist, so a stale first-viewport snapshot must not be reused.
                AccessibilityScanner.invalidateSwiftUIElementCache()

                for item in runWorkflows(on: hostingController.view) {
                    let key = dedupKey(for: item, scrollView: scrollView)
                    if seenResultKeys.insert(key).inserted {
                        combinedResults.append(item)
                        capturedLocations[item.id] = capturedLocation(for: item, scrollView: scrollView)
                    }
                }

                for hv in AccessibilityScanner.findAllHostingViews(in: hostingController.view) {
                    for el in AccessibilityScanner.collectSwiftUIElements(from: hv) where isInteractiveControl(el) {
                        seenElementKeys.insert(elementKey(el))
                    }
                }
            }

            // Warm-up sweep — scroll the whole range once WITHOUT recording.
            //
            // SwiftUI builds the accessibility elements for composite controls (Stepper,
            // compact DatePicker) only once something asks for that region, so a control
            // whose row has never been laid out contributes nothing but its section header
            // to the tree. Sweeping first gives every row a chance to render and publish
            // its elements before the capture pass runs.
            if let scrollView {
                let viewportHeight = scrollView.bounds.height
                if viewportHeight > 0 {
                    var y: CGFloat = 0
                    var steps = 0
                    while steps < 50 {
                        scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: false)
                        window.layoutIfNeeded()
                        try? await Task.sleep(nanoseconds: 120_000_000)
                        window.layoutIfNeeded()
                        AccessibilityScanner.invalidateSwiftUIElementCache()
                        _ = AccessibilityScanner.findAllHostingViews(in: hostingController.view)
                            .flatMap { AccessibilityScanner.collectSwiftUIElements(from: $0) }
                        let maxOffset = max(0, scrollView.contentSize.height - viewportHeight)
                        if y >= maxOffset { break }
                        y = min(y + viewportHeight * 0.7, maxOffset)
                        steps += 1
                    }
                    scrollView.setContentOffset(.zero, animated: false)
                    window.layoutIfNeeded()
                    try? await Task.sleep(nanoseconds: 400_000_000)
                    window.layoutIfNeeded()
                }
            }

            await captureCurrentViewport()

            // SwiftUI's Form/List is backed by a lazily-rendering UITableView — only rows
            // currently within (or near) the visible viewport are instantiated, so off-screen
            // content isn't part of the accessibility tree until scrolled into view. Step
            // through the full scrollable range so every row gets captured at least once.
            if let scrollView {
                let viewportHeight = scrollView.bounds.height
                if viewportHeight > 0 {
                    let step = viewportHeight * 0.7
                    var offset: CGFloat = step
                    var lastReachedOffset: CGFloat = scrollView.contentOffset.y

                    // contentSize is re-read on every iteration instead of being captured
                    // once. A lazily-rendering Form only reports the height of the rows it
                    // has instantiated so far, and that grows as we scroll — reading it a
                    // single time up front stopped the sweep at the height known while
                    // still at the top of the screen, so the final sections never rendered,
                    // never entered the accessibility tree, and were never scanned. On the
                    // Pass/Partial screens that silently skipped the "Save Draft" and
                    // "Delete Account" buttons entirely.
                    while offset < scrollView.contentSize.height {
                        let maxOffset = max(0, scrollView.contentSize.height - viewportHeight)
                        let clamped = min(offset, maxOffset)
                        scrollView.setContentOffset(CGPoint(x: 0, y: clamped), animated: false)
                        await captureCurrentViewport()
                        // Stop if we can no longer advance, so a Form whose contentSize
                        // keeps growing can't spin here forever.
                        if clamped <= lastReachedOffset { break }
                        lastReachedOffset = clamped
                        offset += step
                    }

                    // Always capture the exact bottom too, in case the loop overshot past it.
                    let finalBottom = max(0, scrollView.contentSize.height - viewportHeight)
                    if finalBottom > lastReachedOffset {
                        scrollView.setContentOffset(CGPoint(x: 0, y: finalBottom), animated: false)
                        await captureCurrentViewport()
                    }
                    scrollView.setContentOffset(.zero, animated: false)
                }
            }

            let elementCount = seenElementKeys.count
            // Drop the UIKit backing-view copies first, then collapse identical
            // manual-review rows, so one control yields one row.
            let deduped = removingBackingViewDuplicates(combinedResults, scrollView: scrollView)
            let screenLevel = collapsingScreenLevelFindings(deduped)
            let oneFamily = keepingButtonFamilyForButtons(screenLevel)
            let specificOnly = droppingGeneralWhenSpecificExists(oneFamily)
            let singleRuled = droppingDescriptivenessForDuplicateNames(specificOnly)
            let screenResults = collapsingRepeatedValidateRows(singleRuled)
            reporter.addScan(screenName: entry.name, screenClass: entry.className, elementCount: elementCount, results: screenResults, locations: capturedLocations)

            let failCount = screenResults.filter { $0.record.status.lowercased() == "fail" }.count
            let ruleCount = Set(screenResults.map { $0.record.issueVariable }).count
            print("[A11yDemo] ✓ \(entry.name) — \(elementCount) elements, \(ruleCount) rules, \(failCount) failures")
        }

        window.rootViewController = originalRootVC
        window.layoutIfNeeded()

        reporter.writeSummary()
    }
}
