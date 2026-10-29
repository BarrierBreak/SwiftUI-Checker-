import SwiftUI

/// KEYBOARD LINKS — Pass tier.
///
/// Every link is a SwiftUI `Link`, which Tab reaches and Space or Return follows.
///
/// Elements covered (2) — nothing is reported:
///   1. "Terms of service"  — Link
///   2. "Privacy policy"    — Link
struct AccessibleKeyboardLinkPass: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Link("Terms of service", destination: URL(string: "https://example.com/terms")!)
                    .srcLine()

                Link("Privacy policy", destination: URL(string: "https://example.com/privacy")!)
                    .srcLine()
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Keyboard Links (Pass)")
        }
    }
}

#Preview {
    AccessibleKeyboardLinkPass()
}
