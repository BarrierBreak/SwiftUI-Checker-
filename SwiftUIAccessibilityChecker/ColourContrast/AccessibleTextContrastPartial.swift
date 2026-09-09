import SwiftUI

/// TEXT CONTRAST — Partial tier, solid backgrounds (WCAG 1.4.3 AA).
///
/// Nothing here is glaringly low contrast. Every sample is readable to most sighted users in
/// good light, which is exactly why these survive design review. They fail on the arithmetic,
/// and by margins small enough that how the rule is implemented decides the answer.
///
/// On UIKit that produces three distinct kinds of near-miss — rounding (4.478:1 read as 4.5),
/// threshold (bold at 13pt is NOT large text), and level (AA pass, AAA fail). On SwiftUI only
/// one of the three survives, and the reason is worth stating plainly because it is what makes
/// this the tier that tests the rule rather than the screen:
///
///   **Every ratio on this screen sits between 3:1 and 4.5:1** — the band where the verdict is
///   decided entirely by which threshold the rule picks. SwiftUI cannot read a font, so it
///   guesses "large text" from the element's frame HEIGHT, and `.padding(10)` around 17pt text
///   clears that guess. So these controls are judged against the LENIENT 3:1 bar for a reason
///   that has nothing to do with their type size, and most of them pass on that basis while
///   failing WCAG as written. The rounding cases are not reproducible here at all: the sampler
///   biases a measured ratio below its true value by an amount that depends on the glyph, so a
///   control at 4.478:1 cannot be distinguished from one at 4.52:1.
///
/// The exception is row 4. An interactive element is always held to the strict 4.5:1, because a
/// small label inside a 44pt touch target would otherwise measure as "large" purely because of
/// its tap area — so the button is the one control here whose threshold is not a layout
/// artefact, and the one whose verdict is worth pinning.
///
/// Element-by-element — all in the 3:1–4.5:1 band, so all AA failures as WCAG defines them:
///   1.  Body 17pt         — #777777 on #FFFFFF → 4.48:1  (misses AA by 0.02)
///   2.  Large 18pt        — #959595 on #FFFFFF → 3.00:1  (misses large AA by 0.005)
///   3.  Bold 13pt         — #8A8A8E on #FFFFFF → 3.44:1  (bold, but NOT large: needs 14pt)
///   4.  Button title      — #FFFFFF on #2F80ED → 3.87:1  (interactive → strict 4.5:1)
///   5.  Caption 13pt      — #8A8A8E on #FFFFFF → 3.44:1
///   6.  Cell subtitle     — #8A8A8E on #FFFFFF → 3.44:1
///   7.  Section header    — #8A8A8E on #FFFFFF → 3.44:1
///   8.  Badge 11pt        — #FFFFFF on #2F80ED → 3.87:1
///   9.  Error 13pt        — #FF3B30 on #FFFFFF → 3.55:1  (the stock system red)
///   10. Placeholder 17pt  — #8A8A8E on #FFFFFF → 3.44:1  (NOT exempt)
///
/// Scenario 10 is the counterpart to the Pass screen's disabled control. Placeholder text is
/// real text in an active field and carries the full 4.5:1 requirement. It is frequently
/// mistaken for exempt because it looks like a hint, and the stock placeholder colour does not
/// meet AA. A ruleset that exempts placeholders is under-reporting.
struct AccessibleTextContrastPartial: View {

    @State private var email = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 1. Twenty-two thousandths below the bar, and visually indistinguishable
                    // from the Pass screen's samples. The single most common false negative in
                    // contrast tooling — and unreachable through a pixel sampler, whose own
                    // bias is larger than the margin being tested.
                    contrastCard("Body text at 17pt", size: 17, foreground: "#777777")
                        .srcLine()

                    // 2. Five thousandths below the 3:1 bar for large text: the same rounding
                    // trap at the other threshold.
                    contrastCard("Large headline at 18pt", size: 18, foreground: "#959595")
                        .srcLine()

                    // 3. The bold trap. 13pt bold is NOT large text — WCAG requires 14pt or
                    // larger when bold. A checker that treats any bold text as large applies
                    // 3:1, sees 3.44:1 and passes it; the correct threshold is 4.5:1.
                    contrastCard("Bold, but only 13pt", size: 13, foreground: "#8A8A8E")
                        .srcLine()

                    // 4. A very common brand blue. 3.87:1 with white passes as large text and
                    // fails as normal, so the same button is compliant with a 20pt title and
                    // non-compliant with a 17pt one. Interactive, so the strict bar applies.
                    Button {
                        // Intentionally does nothing: this screen is about the title's colour.
                    } label: {
                        cardBody("Continue", size: 17,
                                 foreground: "#FFFFFF", background: "#2F80ED")
                    }
                    .srcLine()

                    // 5. The classic "grey it out because it is less important" failure. Small
                    // text has no exemption.
                    contrastCard("Last updated 3 minutes ago", size: 13, foreground: "#8A8A8E")
                        .srcLine()

                    // 6. Same colour on a cell subtitle, where secondary styling is the norm.
                    contrastCard("Arriving Thursday, 14 March", size: 15, foreground: "#8A8A8E")
                        .srcLine()

                    // 7. Uppercase is not a size: a section header at 13pt is normal text.
                    contrastCard("CONNECTIVITY", size: 13, foreground: "#8A8A8E")
                        .srcLine()

                    // 8. A badge at 11pt on a mid-tone tint. Needs 4.5:1 and does not reach it.
                    contrastCard("3 NEW", size: 11,
                                 foreground: "#FFFFFF", background: "#2F80ED")
                        .srcLine()

                    // 9. The stock system red against white is 3.55:1. Error text is the worst
                    // possible place for a marginal ratio.
                    contrastCard("Enter a valid email address", size: 13, foreground: "#FF3B30")
                        .srcLine()

                    // 10. A real TextField rather than a Text, so the placeholder is the
                    // system's own and the row tests what the rule does with a field that has
                    // no value yet — the state a form is in when the user first sees it.
                    TextField("", text: $email, prompt:
                        Text("Email address").foregroundColor(Color(hex: "#8A8A8E"))
                    )
                    .font(.system(size: 17, weight: .heavy))
                    .foregroundColor(Color(hex: "#3D3D3D"))
                    .padding(10)
                    .frame(maxWidth: 300, alignment: .leading)
                    .background(Color(hex: "#FFFFFF"))
                    .srcLine()
                }
                .padding()
            }
            .navigationTitle("Text Contrast (Partial)")
        }
    }
}

#Preview {
    AccessibleTextContrastPartial()
}
