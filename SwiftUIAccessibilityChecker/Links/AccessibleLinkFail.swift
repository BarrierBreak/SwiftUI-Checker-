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
                }
                .padding(24)
            }
            .navigationTitle("Red Link (Fail)")
        }
    }
}
 
// MARK: - Test Case 2: Green Link
 
struct AccessibleLinkGreenFail: View {
 
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(
                        makeColorOnlyLinkedText(
                            before: "Learn more in our ",
                            link: "privacy policy",
                            after: " for details.",
                            url: "https://example.com/privacy"
                        )
                    )
                    .tint(.green)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Green Link (Fail)")
        }
    }
}
 
// MARK: - Test Case 3: Purple Link
 
struct AccessibleLinkPurpleFail: View {
 
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
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
                }
                .padding(24)
            }
            .navigationTitle("Purple Link (Fail)")
        }
    }
}
 
// MARK: - Test Case 4: Orange Link
 
struct AccessibleLinkOrangeFail: View {
 
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
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
            .navigationTitle("Orange Link (Fail)")
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
    // The link has no underline or additional visual indicator.
    result.append(linkedText)
    result.append(AttributedString(after))
 
    return result
}
 
// MARK: - Previews
 
#Preview("Red Link - Fail") {
    AccessibleLinkFail()
}
 
#Preview("Green Link - Fail") {
    AccessibleLinkGreenFail()
}
 
#Preview("Purple Link - Fail") {
    AccessibleLinkPurpleFail()
}
 
#Preview("Orange Link - Fail") {
    AccessibleLinkOrangeFail()
}

#Preview {
    AccessibleLinkFail()
}
