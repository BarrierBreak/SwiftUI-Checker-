import SwiftUI

/// KEYBOARD LINKS — Partial tier.
///
/// One link a keyboard can use, one it cannot.
///
/// Elements covered (2):
///   1. "Terms of service"  — Link                              → nothing
///   2. "Help centre"       — Text with a tap gesture           → BB41067 Fail
struct AccessibleKeyboardLinkPartial: View {
    @State private var opened = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Link("Terms of service", destination: URL(string: "https://example.com/terms")!)
                    .srcLine()

                Text("Help centre")
                    .foregroundColor(.blue)
                    .onTapGesture { opened.toggle() }
                    .accessibilityAddTraits(.isLink)
                    .srcLine()
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Keyboard Links (Partial)")
        }
    }
}

#Preview {
    AccessibleKeyboardLinkPartial()
}
