import SwiftUI

/// TARGET SIZE — Fail tier.
///
/// WCAG 2.5.8 checks size first, and only then its exceptions:
///   • a control at least 24×24pt passes on size alone, whatever is next to it;
///   • a control smaller than that passes only if one of the four exceptions applies. The
///     one at work here is SPACING, which is a circle test: a 24pt-diameter circle centred
///     on the target must not overlap another target or another undersized target's circle,
///     so two undersized targets need their centres at least 24pt apart. That is far more
///     permissive than "24pt of clear space on each side", which is why these gaps are 2pt.
///
/// So the only shape that actually fails is a control that is BOTH undersized AND crowded,
/// and every control on this screen is exactly that. Each one is undersized by a different
/// amount and crowded from a different direction, so a report against this screen should
/// name a different measurement each time.
///
/// Sizes and gaps are set with explicit `.frame` and stack spacing rather than padding, so
/// the geometry the rule measures is the geometry written here.
/// Deliberately broken; reference only.
///
/// Element-by-element:
///   1+2. Tiny pair, side by side   — 16×16pt, 2pt apart horizontally
///   3+4. Small pair, stacked       — 20×20pt, 2pt apart vertically
///   5.   Small beside a big button — 18×18pt, 2pt from a 44pt neighbour
///   6+7. Toolbar icons             — 20×20pt, 2pt apart, the classic dense toolbar
struct AccessibleTargetSizeFail: View {

    @State private var lastTapped = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 48) {

                    // MARK: 1 and 2 — undersized and crowded horizontally
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tiny pair, 2pt apart").font(.headline)
                        HStack(spacing: 2) {
                            Button { lastTapped = "Dismiss" } label: {
                                Image(systemName: "xmark")
                            }
                            .frame(width: 16, height: 16)
                            .accessibilityLabel("Dismiss")
                            .srcLine()

                            Button { lastTapped = "Confirm" } label: {
                                Image(systemName: "checkmark")
                            }
                            .frame(width: 16, height: 16)
                            .accessibilityLabel("Confirm")
                            .srcLine()
                        }
                    }

                    // MARK: 3 and 4 — undersized and crowded vertically
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Small pair, 2pt apart").font(.headline)
                        VStack(spacing: 2) {
                            Button { lastTapped = "Increase" } label: {
                                Image(systemName: "chevron.up")
                            }
                            .frame(width: 20, height: 20)
                            .accessibilityLabel("Increase quantity")
                            .srcLine()

                            Button { lastTapped = "Decrease" } label: {
                                Image(systemName: "chevron.down")
                            }
                            .frame(width: 20, height: 20)
                            .accessibilityLabel("Decrease quantity")
                            .srcLine()
                        }
                    }

                    // MARK: 5 — undersized, and crowded by a control that itself passes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Small icon beside a full-size button").font(.headline)
                        HStack(spacing: 2) {
                            Button { lastTapped = "Info" } label: {
                                Image(systemName: "info.circle")
                            }
                            .frame(width: 18, height: 18)
                            .accessibilityLabel("More information")
                            .srcLine()

                            // Passes on size alone: 44×44 is above the minimum, so the 10pt
                            // gap is not measured against it. Only its small neighbour is
                            // reported — which is the asymmetry this pair exists to show.
                            Button("Continue") { lastTapped = "Continue" }
                                .frame(width: 44, height: 44)
                                .srcLine()
                        }
                    }

                    // MARK: 6 and 7 — the dense toolbar
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Toolbar icons, 2pt apart").font(.headline)
                        HStack(spacing: 2) {
                            Button { lastTapped = "Bold" } label: {
                                Image(systemName: "bold")
                            }
                            .frame(width: 20, height: 20)
                            .accessibilityLabel("Bold")
                            .srcLine()

                            Button { lastTapped = "Italic" } label: {
                                Image(systemName: "italic")
                            }
                            .frame(width: 20, height: 20)
                            .accessibilityLabel("Italic")
                            .srcLine()
                        }
                    }
                }
                .padding(24)
            }
            .navigationTitle("Target Size (Fail)")
        }
    }
}

#Preview {
    AccessibleTargetSizeFail()
}
