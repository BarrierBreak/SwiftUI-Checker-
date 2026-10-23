import SwiftUI

/// LINKS — Fail tier.
///
/// Every link sits inside a sentence and is told apart from the words around it by colour
/// alone. A Markdown link in a SwiftUI `Text` is drawn in the tint colour with no underline.
/// Each reports BB40306 "Link color differentiation check" — a Validate row, for a person to
/// judge.
///
/// Elements covered (3) — every one is reported:
///   1. "terms of service"   — colour only
///   2. "privacy policy"     — colour only
///   3. "help centre"        — colour only
struct AccessibleLinkFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Before you continue, please read our [terms of service](https://example.com/terms) and accept them.")
                        .srcLine()

                    Text("We look after your data as described in our [privacy policy](https://example.com/terms) at all times.")
                        .srcLine()

                    Text("If something goes wrong, visit the [help centre](https://example.com/terms) for step by step guidance.")
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Links (Fail)")
        }
    }
}

#Preview {
    AccessibleLinkFail()
}
