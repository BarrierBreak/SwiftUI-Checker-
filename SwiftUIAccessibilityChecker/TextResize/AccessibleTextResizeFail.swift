import SwiftUI

/// TEXT RESIZE — Fail tier. WCAG 1.4.4.
///
/// No `Text` here responds to the reader's text-size setting, so all five report
/// "Text fails to resize" (BB40031). Raising Larger Text to maximum changes nothing on this
/// screen, which is the defect.
///
/// Two ways to get there, and both appear in real code:
///   • `.font(.system(size:))` — has no scaling form at all
///   • `.font(.custom(_:size:))` without `relativeTo:` — scales only when told to
struct AccessibleTextResizeFail: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Account settings")
                    .font(.system(size: 22))
                    .srcLine()

                Text("Notifications")
                    .font(.system(size: 17, weight: .semibold))
                    .srcLine()

                Text("Choose which updates you want to receive about your orders.")
                    .font(.system(size: 15))
                    .srcLine()

                Text("You can change this at any time.")
                    .font(.system(size: 12))
                    .srcLine()

                // The subtle one: a real font face, a sensible size, and no `relativeTo:`.
                // It reads as deliberate typography rather than as a bug.
                Text("Order updates are sent to the email on your account.")
                    .font(.custom("Helvetica", size: 15))
                    .srcLine()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Text Resize (Fail)")
    }
}
