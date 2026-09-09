import SwiftUI

/// TARGET SIZE — Pass tier.
///
/// Every control is at least 44×44pt — Apple's guidance, comfortably above WCAG 2.5.8's
/// 24pt floor — and they are laid out with generous spacing besides. All of them report
/// "Verify interactive control minimum target size requirements".
///
/// That is a Validate row rather than a silent pass, and it is the point of this screen. A
/// frame is measured at one moment: at the default Dynamic Type size, in portrait, on one
/// device width. None of that is preserved when the text grows or the layout reflows, and a
/// control that clears the line by 2pt today can drop under it on the next screen size. The
/// scan reports what it measured and asks a person to confirm it survives.
///
/// The other half of the lesson is what this screen does NOT get reported for: several of
/// these controls sit close together, and none of them is flagged for it. Size is checked
/// first, and a control that meets the minimum passes whatever is beside it — the spacing
/// exception exists to rescue undersized targets, not to add a second bar for large ones.
///
/// Elements covered (6) — every one is measured, none is a defect:
///   1. Primary action button   — 120×44, standing alone
///   2+3. Adjacent pair         — 88×44 each, deliberately close together
///   4. Icon button             — 44×44, the smallest control here
///   5. Toggle                  — the system control, sized by UIKit
///   6. Slider                  — full width, 44pt tall
struct AccessibleTargetSizePass: View {

    @State private var lastTapped = ""
    @State private var notificationsEnabled = true
    @State private var volume = 0.5

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {

                    // MARK: 1 — the primary action
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Primary action").font(.headline)
                        Button("Continue") { lastTapped = "Continue" }
                            .frame(width: 120, height: 44)
                            .buttonStyle(.borderedProminent)
                            .srcLine()
                    }

                    // MARK: 2 and 3 — close together, and correctly not reported for it
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Adjacent pair, 8pt apart").font(.headline)
                        HStack(spacing: 8) {
                            Button("Save") { lastTapped = "Save" }
                                .frame(width: 88, height: 44)
                                .srcLine()

                            Button("Discard") { lastTapped = "Discard" }
                                .frame(width: 88, height: 44)
                                .srcLine()
                        }
                    }

                    // MARK: 4 — an icon button sized for a finger, not for its glyph
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Icon button").font(.headline)
                        Button { lastTapped = "Share" } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .frame(width: 44, height: 44)
                        .accessibilityLabel("Share this page")
                        .srcLine()
                    }

                    // MARK: 5 — a system control, whose size UIKit decides
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Toggle").font(.headline)
                        Toggle("Enable notifications", isOn: $notificationsEnabled)
                            .srcLine()
                    }

                    // MARK: 6 — a slider, tall enough to grab
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Slider").font(.headline)
                        Slider(value: $volume)
                            .frame(height: 44)
                            .accessibilityLabel("Volume")
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("Target Size (Pass)")
        }
    }
}

#Preview {
    AccessibleTargetSizePass()
}
