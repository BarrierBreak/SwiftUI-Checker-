import SwiftUI

/// TEXT CLIPPING — Partial tier. WCAG 1.4.4.
///
/// A realistic screen: most of the text is free to grow, two pieces are pinned and truncated.
/// The scan should report both "Text is not getting clipped" (BB40030) and "Text getting
/// clipped" (BB40033) side by side, which is what separates this tier from Pass and Fail.
///
/// Three clean, two cut. Both failures are the shape that reaches production most often —
/// marketing and legal copy dropped into a fixed-width slot that was designed against a
/// shorter string than the one it ends up holding.
struct AccessibleTextClippingPartial: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Checkout")
                    .font(.title)
                    .srcLine()

                Text("Review your items before you pay.")
                    .font(.body)
                    .srcLine()

                Text("Total £42.60")
                    .font(.headline)
                    .srcLine()

                // Cut.
                Text("Spend £50 today and get free next-day delivery on this order")
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 150, alignment: .leading)
                    .srcLine()

                Text("Prices include VAT. Delivery charges are calculated at the next step.")
                    .font(.footnote)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 200, alignment: .leading)
                    .srcLine()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Text Clipping (Partial)")
    }
}
