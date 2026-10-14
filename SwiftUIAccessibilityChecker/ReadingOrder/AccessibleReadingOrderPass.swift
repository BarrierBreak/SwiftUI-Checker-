import SwiftUI

/// READING ORDER — Pass tier.
///
/// Two groups of text, each a container in the accessibility tree
/// (`.accessibilityElement(children: .contain)`), and nothing overrides the order SwiftUI
/// follows by default: top to bottom, then left to right. Every container reports BB40135
/// "Reading order is accurate".
///
/// Elements covered:
///   1. Summary group   — three lines, in the order drawn
///   2. Actions group   — Cancel then Save, left to right
///   (and the screen's own two groups, read in the order they are drawn)
struct AccessibleReadingOrderPass: View {

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

                    HStack(spacing: 24) {
                        Text("Cancel")
                        Text("Save")
                    }
                    .accessibilityElement(children: .contain)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Reading Order (Pass)")
        }
    }
}

#Preview {
    AccessibleReadingOrderPass()
}
