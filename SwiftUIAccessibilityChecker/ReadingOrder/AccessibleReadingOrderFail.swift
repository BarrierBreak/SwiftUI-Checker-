import SwiftUI

/// READING ORDER — Fail tier.
///
/// `accessibilitySortPriority` makes VoiceOver read something other than what is drawn first.
/// Here it reverses the order inside two groups, and puts the lower group ahead of the upper
/// one. Each container reports BB40134 "Inaccurate reading order".
///
/// Elements covered — every container fails:
///   1. Summary group   — drawn title → detail → note, read note → detail → title
///   2. Actions group   — drawn Cancel | Save, read Save then Cancel
///   3. The screen      — the Actions group is read before the Summary group above it
struct AccessibleReadingOrderFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Order summary").accessibilitySortPriority(1)
                        Text("Two items, 42 dollars").accessibilitySortPriority(2)
                        Text("Estimated delivery on Friday").accessibilitySortPriority(3)
                    }
                    .accessibilityElement(children: .contain)
                    .srcLine()

                    HStack(spacing: 24) {
                        Text("Cancel").accessibilitySortPriority(1)
                        Text("Save").accessibilitySortPriority(2)
                    }
                    .accessibilityElement(children: .contain)
                    .accessibilitySortPriority(1)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Reading Order (Fail)")
        }
    }
}

#Preview {
    AccessibleReadingOrderFail()
}
