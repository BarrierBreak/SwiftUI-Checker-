import SwiftUI

/// TEXT CONTRAST — Fail tier, solid backgrounds (WCAG 1.4.3 AA).
///
/// Every ratio here is below 3:1, which is the floor for LARGE text, so nothing on this screen
/// passes at any size or weight and no exemption applies. That is a deliberate choice rather
/// than a lack of ambition: the SwiftUI rule infers the large-vs-normal threshold from the
/// element's frame height, so a control between 3:1 and 4.5:1 would be a pass or a failure
/// depending on its padding. Keeping every ratio under the lenient threshold makes the verdict
/// a fact about the colours instead of a fact about the layout.
///
/// Two rows fail in a way that looks like the opposite of a contrast bug:
///
///   • Row 7 is dark-on-dark rather than light-on-light. The sampler splits a crop by
///     luminance and does not assume which side the text is on, so an inverted pairing has to
///     come out as a failure the same way a washed-out one does.
///   • Row 10 is white text on white background — a real regression shape, usually from a
///     theme change that updated one colour and not the other. The text is invisible, the
///     ratio is 1.00:1, and the element is still in the accessibility tree announcing content
///     nobody can see.
///
/// Element-by-element:
///   1.  Body 17pt         — #B4B4B4 on #FFFFFF → 2.07:1
///   2.  Large 18pt        — #B4B4B4 on #FFFFFF → 2.07:1
///   3.  Bold 14pt         — #B4B4B4 on #FFFFFF → 2.07:1
///   4.  Button title      — #FFFFFF on #34C759 → 2.22:1
///   5.  Caption 13pt      — #A6A6A6 on #FFFFFF → 2.43:1
///   6.  Link 15pt         — #7EB8F0 on #FFFFFF → 2.10:1
///   7.  Dark on dark 15pt — #5A5A5E on #1C1C1E → 2.48:1
///   8.  Badge 11pt        — #FFFFFF on #7FC4F0 → 1.90:1
///   9.  Error 13pt        — #FF9A94 on #FFFFFF → 2.04:1
///   10. Invisible 17pt    — #FFFFFF on #FFFFFF → 1.00:1
///
/// Deliberately broken; reference only.
struct AccessibleTextContrastFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 1. Light grey body text. Below the large-text floor, so making the type
                    // bigger does not rescue it — rows 1 to 3 are the same colour at three
                    // sizes to make exactly that point.
                    contrastCard("Body text at 17pt", size: 17, foreground: "#B4B4B4")
                        .srcLine()

                    // 2. The same colour at 18pt. The size relaxation is a floor of 3:1, not
                    // an exemption.
                    contrastCard("Large headline at 18pt", size: 18, foreground: "#B4B4B4")
                        .srcLine()

                    // 3. And at 14pt, which does qualify as large text when bold, and still
                    // falls short.
                    contrastCard("Bold 14pt heading", size: 14, foreground: "#B4B4B4")
                        .srcLine()

                    // 4. White on the bright system green. This pairing is everywhere in
                    // shipping apps because it looks correct on a calibrated display at full
                    // brightness.
                    Button {
                        // Intentionally does nothing: this screen is about the title's colour.
                    } label: {
                        cardBody("Continue", size: 17,
                                 foreground: "#FFFFFF", background: "#34C759")
                    }
                    .srcLine()

                    // 5. Caption at 2.43:1 — greyed out because it is "less important".
                    contrastCard("Last updated 3 minutes ago", size: 13, foreground: "#A6A6A6")
                        .srcLine()

                    // 6. A pale link colour. Links carry a second obligation under 1.4.1 —
                    // they must not rely on colour alone to be identifiable — but this row
                    // fails 1.4.3 on its own terms first.
                    contrastCard("View documentation", size: 15, foreground: "#7EB8F0")
                        .srcLine()

                    // 7. Dark on dark: the same failure at the opposite polarity.
                    contrastCard("Dark text on a dark panel", size: 15,
                                 foreground: "#5A5A5E", background: "#1C1C1E")
                        .srcLine()

                    // 8. Small text on a pale tint — the worst pairing on the screen, and
                    // badges are usually the last thing anyone checks.
                    contrastCard("3 NEW", size: 11,
                                 foreground: "#FFFFFF", background: "#7FC4F0")
                        .srcLine()

                    // 9. A washed-out red that reads as pink and does not register as an
                    // error to anyone.
                    contrastCard("Enter a valid email address", size: 13, foreground: "#FF9A94")
                        .srcLine()

                    // 10. White on white. Invisible, still in the accessibility tree, still
                    // announced by VoiceOver. The mismatch between what is announced and what
                    // is visible is the tell.
                    contrastCard("This paragraph is invisible", size: 17, foreground: "#FFFFFF")
                        .srcLine()
                }
                .padding()
            }
            .navigationTitle("Text Contrast (Fail)")
        }
    }
}

#Preview {
    AccessibleTextContrastFail()
}
