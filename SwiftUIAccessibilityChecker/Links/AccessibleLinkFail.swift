import SwiftUI

/// LINKS — Fail tier.
///
/// Every link sits inside a sentence and is told apart from the words around it by colour
/// alone. A Markdown link in a SwiftUI `Text` is drawn in the tint colour with no underline.
/// Each reports BB40306 "Link color differentiation check" — a Validate row, for a person to
/// judge.
///
/// Elements covered (4) — three are reported:
///   1. "terms of service"        — colour only
///   2. "privacy policy"          — underlined                → nothing
///   3. "help centre"             — colour only
///   4. "product documentation"   — colour only
struct AccessibleLinkFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text(
                        makeColorOnlyLinkedText(
                            before: "Read our ",
                            link: "terms of service",
                            after: " before continuing.",
                            url: "https://example.com/terms"
                        )
                    )
                    .tint(.red)
                    .srcLine()

                    Text(
                        makeUnderlinedLinkedText(
                            before: "Learn more in our ",
                            link: "privacy policy",
                            after: " for details.",
                            url: "https://example.com/privacy"
                        )
                    )
                    .tint(.green)
                    .srcLine()

                    Text(
                        makeColorOnlyLinkedText(
                            before: "For assistance, visit the ",
                            link: "help centre",
                            after: " for guidance.",
                            url: "https://example.com/help"
                        )
                    )
                    .tint(.purple)
                    .srcLine()

                    Text(
                        makeColorOnlyLinkedText(
                            before: "View the ",
                            link: "product documentation",
                            after: " to get started.",
                            url: "https://example.com/docs"
                        )
                    )
                    .tint(.orange)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Color Only Links (Fail)")
        }
    }
}

private func makeColorOnlyLinkedText(
    before: String,
    link: String,
    after: String,
    url: String
) -> AttributedString {

    var result = AttributedString(before)

    var linkedText = AttributedString(link)
    linkedText.link = URL(string: url)

    // Intentional failure:
    // Link is identified only by color.
    result.append(linkedText)
    result.append(AttributedString(after))

    return result
}

private func makeUnderlinedLinkedText(
    before: String,
    link: String,
    after: String,
    url: String
) -> AttributedString {

    var result = AttributedString(before)

    var linkedText = AttributedString(link)
    linkedText.link = URL(string: url)
    // The underline sets the link apart by more than colour.
    linkedText.underlineStyle = .single
    result.append(linkedText)
    result.append(AttributedString(after))

    return result
}

#Preview {
    AccessibleLinkFail()
}
