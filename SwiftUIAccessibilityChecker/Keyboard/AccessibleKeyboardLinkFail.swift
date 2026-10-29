import SwiftUI

/// KEYBOARD LINKS — Fail tier.
///
/// Every link is a `Text` with the link role and a tap gesture. It is not a `Link` or a
/// `Button`, and it is not focusable, so Tab and Full Keyboard Access skip it. Each reports
/// BB41067 "Link not keyboard operable".
///
/// Elements covered (2) — every one fails:
///   1. "Terms of service"  — tap gesture only
///   2. "Help centre"       — tap gesture only
struct AccessibleKeyboardLinkFail: View {
    @State private var opened = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Text("Terms of service")
                    .foregroundColor(.blue)
                    .onTapGesture { opened.toggle() }
                    .accessibilityAddTraits(.isLink)
                    .srcLine()

                Text("Help centre")
                    .foregroundColor(.blue)
                    .onTapGesture { opened.toggle() }
                    .accessibilityAddTraits(.isLink)
                    .srcLine()
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Keyboard Links (Fail)")
        }
    }
}

#Preview {
    AccessibleKeyboardLinkFail()
}
