import SwiftUI

/// READING ORDER — Partial tier.
///
/// Two groups of text. The first is read in the order it is drawn; the second has its order
/// reversed with `accessibilitySortPriority`.
///
/// Elements covered:
///   1. Summary group   — three lines in the order drawn                  → BB40135 Pass
///   2. Details group   — drawn top to bottom, read bottom to top         → BB40134 Fail
///   (and the screen's own two groups, read in the order they are drawn   → BB40135 Pass)
struct AccessibleReadingOrderPartial: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Order summary")
                        Text("Two items, 42 dollars")
                        Text("Estimated delivery on Friday")
                    }
                    .accessibilityElement(children: .contain)
                    .srcLine()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Shipping address").accessibilitySortPriority(1)
                        Text("12 Garden Road").accessibilitySortPriority(2)
                        Text("Springfield").accessibilitySortPriority(3)
                    }
                    .accessibilityElement(children: .contain)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Reading Order (Partial)")
        }
    }
}

#Preview {
    AccessibleReadingOrderPartial()
}
