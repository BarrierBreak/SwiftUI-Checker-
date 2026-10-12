import SwiftUI

/// HIDDEN FROM SCREEN READER — Partial tier.
///
/// Nothing here stops a screen-reader user operating anything. Four pieces of readable
/// content are kept out of the accessibility tree, and whether that is right depends on
/// something the scan cannot see: does a screen-reader user get this information some other
/// way? Each is reported as BB40057 "Check if content needs to be hidden from screen reader
/// users" — a Validate row for a person to decide.
///
/// Decided from the source, not the running screen: SwiftUI never hands a hidden view to
/// the hosting view. See source_role_linter.py, check_swiftui_hidden_from_screen_reader.
///
/// Elements covered (7):
///   1. Order status     — informative Text, hidden                       → Validate
///   2. Total            — Text that repeats the button below it, hidden  → Validate
///   3. Low-stock image  — described Image, hidden                        → Validate
///   4. Footnote         — Text inside a hidden VStack                    → Validate
///   5. Pay button       — exposed, not reported
///   6. Heading          — exposed, not reported
///   7. Decorative image — no description, hidden: not reported
struct AccessibleHiddenPartial: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text("Checkout")
                        .font(.headline)
                        .srcLine()

                    Text("Order #4821 confirmed")
                        .accessibilityHidden(true)
                        .srcLine()

                    Text("Total: $42.00")
                        .accessibilityHidden(true)
                        .srcLine()

                    Button("Pay $42.00") {}
                        .buttonStyle(.borderedProminent)
                        .srcLine()

                    Image(systemName: "exclamationmark.triangle")
                        .accessibilityLabel("Warning: low stock")
                        .accessibilityHidden(true)
                        .srcLine()

                    VStack(alignment: .leading) {
                        Text("Prices include tax")
                            .srcLine()
                    }
                    .accessibilityHidden(true)

                    // Decoration with no description — hiding it is right and is not reported.
                    Image(systemName: "sparkles")
                        .accessibilityHidden(true)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Hidden (Partial)")
        }
    }
}

#Preview {
    AccessibleHiddenPartial()
}
