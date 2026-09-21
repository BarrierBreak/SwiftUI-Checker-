import SwiftUI

/// TEXT RESIZE — Pass tier. WCAG 1.4.4.
///
/// Every `Text` here uses a Dynamic Type text style, so all five report
/// "Text can be resized" (BB40032).
///
/// The verdict comes from source, not from the running view: `_UIHostingView` has no
/// subviews, so there is no UILabel for the scan to read `adjustsFontForContentSizeCategory`
/// off. The linter's SWIFTUI_SCALABLE_FONT check reads the modifier chain instead, and
/// `.font(.body)` and friends are unambiguous about scaling.
struct AccessibleTextResizePass: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Account settings")
                    .font(.title)
                    .srcLine()

                Text("Notifications")
                    .font(.headline)
                    .srcLine()

                Text("Choose which updates you want to receive about your orders.")
                    .font(.body)
                    .srcLine()

                Text("You can change this at any time.")
                    .font(.footnote)
                    .srcLine()

                // The custom-face form that still scales: `relativeTo:` is what ties the
                // size to the reader's setting. Without it this would be a fixed size.
                Text("Order updates are sent to the email on your account.")
                    .font(.custom("Helvetica", size: 15, relativeTo: .body))
                    .srcLine()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Text Resize (Pass)")
    }
}
