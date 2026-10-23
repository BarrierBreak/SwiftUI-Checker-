import SwiftUI

/// LINKS — Pass tier.
///
/// Every link sits inside a sentence and is set apart from the words around it by more than its
/// colour: an underline, or a heavier weight. SwiftUI links written as Markdown in a string are
/// only coloured, so these are built as an AttributedString where each link run is styled.
/// Nothing is reported.
///
/// Elements covered (3) — none is a defect:
///   1. "terms of service"   — underlined
///   2. "privacy policy"     — underlined
///   3. "help centre"        — bold
struct AccessibleLinkPass: View {

    private var sentence0: AttributedString {
        var a = AttributedString("Before you continue, please read our terms of service and accept them.")
        if let range = a.range(of: "terms of service") {
            a[range].link = URL(string: "https://example.com/terms")
            a[range].underlineStyle = .single
        }
        return a
    }

    private var sentence1: AttributedString {
        var a = AttributedString("We look after your data as described in our privacy policy at all times.")
        if let range = a.range(of: "privacy policy") {
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

                    Text(sentence1)
                        .srcLine()

                    Text(sentence2)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Links (Pass)")
        }
    }
}

#Preview {
    AccessibleLinkPass()
}
