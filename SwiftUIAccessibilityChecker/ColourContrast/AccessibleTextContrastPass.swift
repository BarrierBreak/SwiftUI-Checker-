import SwiftUI

/// TEXT CONTRAST — Pass tier, solid backgrounds (WCAG 1.4.3 AA).
///
/// The UIKit twin of this screen reads `textColor` and the composited background off real
/// views, so its ratios are exact and WCAG's large-vs-normal classification is a fact about
/// the font. SwiftUI hands the rule neither. It screenshots the window, crops each element's
/// frame, clusters the pixels into a light group and a dark group, and infers "large text"
/// from the element's frame HEIGHT — so two things behave differently here and both change
/// what a fixture can honestly claim:
///
///   • THE RATIO IS SAMPLED, NOT COMPUTED. The sampler takes the lightest fifth of the dark
///     cluster as the foreground, which biases a measured ratio below its true value by an
///     amount that depends on the glyph, the size and the weight. A control at 4.6:1 would
///     read as a pass sometimes and a failure other times.
///   • THE THRESHOLD IS GUESSED FROM LAYOUT. `.padding(10)` around 17pt text makes the frame
///     about 41pt tall, which clears the 22pt large-text guess, so the same card is judged
///     against 3:1 rather than 4.5:1 purely because of its padding.
///
/// So this screen does not try to reproduce the UIKit screen's narrow margins. Every pair
/// below clears 4.5:1 with room to spare, which means the verdict is a pass under BOTH
/// thresholds and does not depend on which one the height heuristic picks. The narrow cases
/// stay on the UIKit screen, where they can be measured exactly.
///
/// Element-by-element — every ratio computed against the card's own background:
///   1.  Body 17pt         — #595959 on #FFFFFF → 7.00:1
///   2.  Large 18pt        — #595959 on #FFFFFF → 7.00:1
///   3.  Bold 14pt         — #595959 on #FFFFFF → 7.00:1
///   4.  Button title      — #FFFFFF on #0B5FA5 → 6.57:1  (interactive: always 4.5:1)
///   5.  Caption 13pt      — #595959 on #FFFFFF → 7.00:1
///   6.  Cell subtitle     — #666666 on #FFFFFF → 5.74:1
///   7.  Section header    — #595959 on #FFFFFF → 7.00:1
///   8.  Badge 11pt        — #FFFFFF on #1E6B36 → 6.54:1
///   9.  Error 13pt        — #B3261E on #FFFFFF → 6.54:1
///   10. Disabled title    — #FFFFFF on #0B5FA5 → 6.57:1  (see below)
///
/// Scenario 10 is the exemption case, and it behaves differently from its UIKit counterpart.
/// WCAG 1.4.3 exempts text in an inactive control, and UIKit's rule enforces that by skipping
/// disabled `UIControl`s. SwiftUI publishes a disabled button as an accessibility element with
/// the `.notEnabled` trait rather than removing it, and the pixel sampler measures whatever is
/// on screen — so this row IS measured. It is given a passing colour pair deliberately: a
/// disabled control with a low ratio would be reported here, and that report would be a false
/// positive rather than a finding.
struct AccessibleTextContrastPass: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 1. Body text. Normal text needs 4.5:1; 7.00:1 clears AAA as well.
                    contrastCard("Body text at 17pt", size: 17, foreground: "#595959")
                        .srcLine()

                    // 2. Large text. Whichever threshold the height guess lands on, 7.00:1
                    // is above both, which is the property this whole screen is built on.
                    contrastCard("Large headline at 18pt", size: 18, foreground: "#595959")
                        .srcLine()

                    // 3. Bold 14pt is large text under WCAG. The rule cannot read the weight
                    // here, so this row is about the colour holding up either way.
                    contrastCard("Bold 14pt heading", size: 14, foreground: "#595959")
                        .srcLine()

                    // 4. A tinted button. The ratio is against the button's own fill, not the
                    // page — and an interactive element is always held to the strict 4.5:1,
                    // because a small label inside a 44pt touch target would otherwise measure
                    // as "large" purely because of the tap area.
                    Button {
                        // Intentionally does nothing: this screen is about the title's colour.
                    } label: {
                        cardBody("Continue", size: 17,
                                 foreground: "#FFFFFF", background: "#0B5FA5")
                    }
                    .srcLine()

                    // 5. Small text gets no relaxation — 13pt still needs 4.5:1. Secondary
                    // text is where most real failures live, because "secondary" gets read as
                    // licence to lighten.
                    contrastCard("Last updated 3 minutes ago", size: 13, foreground: "#595959")
                        .srcLine()

                    // 6. 5.74:1 — comfortably past AA, short of the 7:1 AAA bar.
                    contrastCard("Arriving Thursday, 14 March", size: 15, foreground: "#666666")
                        .srcLine()

                    // 7. Uppercase is not a size: this is still normal text.
                    contrastCard("CONNECTIVITY", size: 13, foreground: "#595959")
                        .srcLine()

                    // 8. A badge on a dark green fill. The bright system green most apps reach
                    // for gives 2.22:1 with white — that version is on the Fail screen.
                    contrastCard("3 NEW", size: 11,
                                 foreground: "#FFFFFF", background: "#1E6B36")
                        .srcLine()

                    // 9. A darkened red rather than the system red, which only reaches 3.55:1
                    // against white. Error text is the worst possible place for a near miss,
                    // since it is what the user must read to recover from a mistake.
                    contrastCard("Enter a valid email address", size: 13, foreground: "#B3261E")
                        .srcLine()

                    // 10. Disabled, and measured anyway — see the note in the type comment.
                    Button {
                        // Intentionally does nothing.
                    } label: {
                        cardBody("Save Draft", size: 17,
                                 foreground: "#FFFFFF", background: "#0B5FA5")
                    }
                    .disabled(true)
                    .srcLine()
                }
                .padding()
            }
            .navigationTitle("Text Contrast (Pass)")
        }
    }
}

// MARK: - Shared card shapes
// Used by the Partial and Fail tiers too, with different colours passed in, so the only
// difference between the tiers is the values rather than the shape.

/// One sample: text in a known colour on a known opaque background.
///
/// `.padding(10)` and an explicit `.background` are not decoration — they are what makes the
/// element samplable. The crop needs background pixels around the glyphs to cluster against,
/// and a card whose background is inherited from the page gives the sampler the page's colour
/// wherever the element's frame happens to fall.
func contrastCard(
    _ text: String,
    size: CGFloat,
    foreground: String,
    background: String = "#FFFFFF"
) -> some View {
    cardBody(text, size: size, foreground: foreground, background: background)
}

/// The card without the `.srcLine()` tag, so a `Button` can wrap it as its own label and the
/// tag can go on the button instead — the button is the accessibility element there, and a tag
/// on its inner text would name a view the report never attributes a finding to.
func cardBody(
    _ text: String,
    size: CGFloat,
    foreground: String,
    background: String = "#FFFFFF"
) -> some View {
    Text(text)
        .font(.system(size: size, weight: .heavy))
        .foregroundColor(Color(hex: foreground))
        .padding(10)
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color(hex: background))
}

extension Color {
    /// Fixed sRGB from a hex string. Deliberately NOT a semantic or system colour, so every
    /// ratio in these fixtures is deterministic and does not shift with the appearance or with
    /// an accessibility setting.
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        var value: UInt64 = 0
        Scanner(string: s).scanHexInt64(&value)
        self.init(
            red: Double((value & 0xFF0000) >> 16) / 255,
            green: Double((value & 0x00FF00) >> 8) / 255,
            blue: Double(value & 0x0000FF) / 255
        )
    }
}

#Preview {
    AccessibleTextContrastPass()
}
