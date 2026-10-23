import SwiftUI

/// LINKS — Partial tier.
///
/// Some links are set apart by more than colour and some are not.
///
/// Elements covered (3):
///   1. "terms of service"   — underlined                    → nothing
///   2. "privacy policy"     — colour only                   → BB40306 Validate
///   3. "help centre"        — bold                          → nothing
struct AccessibleLinkPartial: View {

    private var sentence0: AttributedString {
        var a = AttributedString("Before you continue, please read our terms of service and accept them.")
        if let range = a.range(of: "terms of service") {
            a[range].link = URL(string: "https://example.com/terms")
            a[range].underlineStyle = .single
        }
        return a
    }

    private var sentence2: AttributedString {
        var a = AttributedString("If something goes wrong, visit the help centre for step by step guidance.")
        if let range = a.range(of: "help centre") {
            a[range].link = URL(string: "https://example.com/terms")
            a[range].inlinePresentationIntent = .stronglyEmphasized
        }
        return a
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(sentence0)
                        .srcLine()

                    Text("We look after your data as described in our [privacy policy](https://example.com/terms) at all times.")
                        .srcLine()

                    Text(sentence2)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Links (Partial)")
        }
    }
}

#Preview {
    AccessibleLinkPartial()
}
