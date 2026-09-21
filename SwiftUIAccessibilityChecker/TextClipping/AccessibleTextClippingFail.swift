import SwiftUI

/// TEXT CLIPPING — Fail tier. WCAG 1.4.4.
///
/// Every `Text` here is pinned to a fixed frame, capped to one or two lines, and given an
/// explicit truncation mode — a combination that exists only to cut text off. All five report
/// "Text getting clipped" (BB40033).
///
/// All three modifiers are required before the rule fires. `.lineLimit(1)` on its own is not
/// a defect — a one-line title that fits is perfectly correct — and flagging it would bury
/// the rows that matter under every heading in the app.
///
/// Every `Text` uses a text style, so resizing is not also reported and the tier stays about
/// clipping alone.
struct AccessibleTextClippingFail: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Estimated delivery Tuesday 14 March between 9am and 6pm")
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 140, alignment: .leading)
                    .srcLine()

                Text("Payment method ending 4417 expires next month")
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(width: 140, alignment: .leading)
                    .srcLine()

                Text("Your parcel is being held at the depot because nobody was home when the courier called.")
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 200, alignment: .leading)
                    .srcLine()

                Text("Refunds are issued to the original payment method and can take up to ten working days to appear.")
                    .font(.body)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(width: 180, alignment: .leading)
                    .srcLine()

                Text("These terms describe how we handle returns, exchanges and refunds.")
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.head)
                    .frame(width: 160, alignment: .leading)
                    .srcLine()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Text Clipping (Fail)")
    }
}
