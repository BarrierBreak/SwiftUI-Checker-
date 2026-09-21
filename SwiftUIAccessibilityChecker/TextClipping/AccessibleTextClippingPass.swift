import SwiftUI

/// TEXT CLIPPING — Pass tier. WCAG 1.4.4.
///
/// Every `Text` is free to grow to the size it needs, so all five report
/// "Text is not getting clipped" (BB40030).
///
/// The SwiftUI verdict is about configuration rather than measurement, and it has to be:
/// `_UIHostingView` has no subviews, so there is no rendered label to measure and no
/// contentSize to compare against bounds. Text with no line cap, or with a minimum scale
/// factor, or marked `.fixedSize()`, provably cannot be cut — which is what this tier
/// demonstrates.
///
/// Every `Text` also uses a text style, so nothing here trips the resize rule and the tier
/// stays about clipping alone.
struct AccessibleTextClippingPass: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // No line cap — wraps to as many lines as it needs.
                Text("Order summary")
                    .font(.headline)
                    .srcLine()

                Text("Your order will arrive between Tuesday and Thursday next week.")
                    .font(.body)
                    .srcLine()

                Text("Delivery times are estimates and can change if the weather is bad or if the courier is held up on an earlier stop.")
                    .font(.body)
                    .srcLine()

                // Capped at one line, but allowed to shrink rather than truncate.
                Text("Contactless delivery is available on request")
                    .font(.body)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .srcLine()

                // fixedSize keeps the text at its ideal size instead of letting the parent
                // squeeze it.
                Text("Leave with a neighbour.")
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .srcLine()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Text Clipping (Pass)")
    }
}
