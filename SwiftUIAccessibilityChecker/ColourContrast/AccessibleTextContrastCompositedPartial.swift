import SwiftUI

/// TEXT CONTRAST — Partial tier, composited and adaptive (WCAG 1.4.3 AA).
///
/// The unifying failure here is CONFIGURATION DEPENDENCE. Every sample passes somewhere: in
/// light mode, at the default content size, at one end of the gradient, with Increase Contrast
/// off, or over the part of the photo that happens to be dark. Test once in one configuration
/// and this entire screen looks compliant.
///
/// That makes it the tier that decides whether the ruleset is genuinely useful, and it splits
/// cleanly into two halves that need different things:
///
///   • ROWS 1–7 are decidable, and the SwiftUI rule decides them — it samples rendered pixels,
///     so opacity, stacked layers and materials are already composited before it looks. What
///     makes them Partial rather than Fail is that each sits in the 3:1–4.5:1 band, where the
///     verdict depends on which threshold the rule picks; and because SwiftUI cannot read a
///     font, it picks from the element's frame HEIGHT. So these are AA failures as WCAG defines
///     them that a height-based classifier can wave through as large text.
///   • ROWS 8–10 are NOT decidable by any single scan, and they are here to mark that
///     boundary. A scan runs in one appearance, at one content size, with Increase Contrast in
///     one state. Row 8 passes in the light mode the scan uses and fails in dark; row 9 ignores
///     the setting entirely, so it looks identical either way; row 10 passes at the default
///     content size and fails at xSmall. None of them can be caught by looking harder at one
///     screenshot — they need the scan repeated across configurations, which is a harness
///     question rather than a rule question.
///
/// Scenarios covered (10):
///   1.  Text opacity 0.5      — effective #808080 on #FFFFFF → 3.95:1
///   2.  Background opacity 0.6 — #FFFFFF on effective #777778 → 4.47:1  (0.03 under AA)
///   3.  Two stacked layers     — resolves lighter than either layer implies → ≈3.3:1
///   4.  Blur material          — #767676 on a light material → ≈4.06:1
///   5.  Secondary on material  — sunk into the material, not statically knowable
///   6.  Gradient               — 6.57:1 at one end, 2.88:1 at the other
///   7.  Image + 30% scrim      — a scrim that exists but is not sufficient → ≈3.11:1
///   8.  Dark mode inverted     — 7.00:1 in light, 2.48:1 in dark: ONE branch tested
///   9.  Increase Contrast      — ignores the setting: 3.44:1 in both states
///   10. Dynamic Type           — large text at the default size, normal text at xSmall
///
/// Scenario 10 deserves its own rule. The text is 18pt at the default content size, which is
/// large text needing 3:1, and it clears that. At xSmall the scaled font renders below 18pt,
/// the text becomes normal text needing 4.5:1, and the same colour now fails. The threshold
/// must be chosen from the RENDERED size at the content size under test, not from the nominal
/// size in the source.
struct AccessibleTextContrastCompositedPartial: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 1. Opacity 0.5 composites black to #808080 — 3.95:1. Enough for large
                    // text, short for the 17pt body text it is used on. Reading the assigned
                    // colour would report 21:1.
                    contrastCard("Text drawn at 50% opacity", size: 17, foreground: "#000000")
                        .opacity(0.5)
                        .srcLine()

                    // 2. Background opacity 0.6 composites #1C1C1E over white to #777778,
                    // giving white text 4.47:1 — three hundredths under AA. The panel looks
                    // solidly dark; it is not.
                    contrastCard("White text on a translucent panel", size: 15,
                                 foreground: "#FFFFFF", background: "#1C1C1E", backgroundOpacity: 0.6)
                        .srcLine()

                    // 3. Two layers, each individually plausible. Two 0.4-opacity dark layers
                    // over white do NOT compose to a dark background — they resolve to a mid
                    // grey, and white text on it falls short. Resolving only the immediate
                    // parent gives a passing answer.
                    contrastCard("Text over two translucent layers", size: 15,
                                 foreground: "#FFFFFF", background: "#1C1C1E", backgroundOpacity: 0.4)
                        .padding(6)
                        .background(Color(hex: "#1C1C1E").opacity(0.4))
                        .srcLine()

                    // 4. A material at roughly 4.06:1: passes as large text, fails at the 15pt
                    // used here. A material also makes the background depend on what is
                    // scrolling underneath, so this ratio is the best case.
                    materialCard("Text over a blur material", foreground: Color(hex: "#767676"))
                        .srcLine()

                    // 5. `.secondary` is designed to sink text into its material. The resulting
                    // colour is not knowable from the source — it is computed by the renderer
                    // from the material and the backdrop — which is itself a finding: the value
                    // cannot be verified statically, so this needs a rendered-pixel check.
                    Text("Secondary style over a material")
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: 300, alignment: .leading)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                        .srcLine()

                    // 6. A gradient from #0B5FA5 to #3AA0E0. White text is 6.57:1 at the left
                    // edge and 2.88:1 at the right, so the first half of the string passes and
                    // the second half does not. Sampling the start of the text, or its centre,
                    // both give a passing result.
                    GradientTextCard(text: "Starts readable and ends unreadable",
                                     from: "#0B5FA5", to: "#3AA0E0", textColor: "#FFFFFF")
                        .srcLine()

                    // 7. A photo with a 30% scrim — large-text territory only, and the caption
                    // is 15pt. A scrim that exists is easily mistaken for a scrim that is
                    // sufficient.
                    ScrimmedImageTextCard(text: "Caption over a photo",
                                          imageColor: "#C8D2DC", scrimOpacity: 0.30,
                                          textColor: "#FFFFFF")
                        .srcLine()

                    // 8. The inverted-branch bug: an appearance-aware colour whose branches are
                    // the wrong way round, so dark mode gets 2.48:1 while light mode gets
                    // 7.00:1. The scan runs in light mode, sees the good branch, and reports a
                    // pass — correctly, for the configuration it measured. The Fail screen
                    // carries the version that fails in every appearance.
                    contrastCard("Darker in dark mode", size: 17,
                                 foregroundColor: Color(UIColor { traits in
                                     traits.userInterfaceStyle == .dark
                                         ? UIColor(red: 0.35, green: 0.35, blue: 0.37, alpha: 1) // #5A5A5E
                                         : UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1) // #595959
                                 }),
                                 background: "#FFFFFF")
                        .srcLine()

                    // 9. Increase Contrast is never consulted. This screen does not read
                    // `colorSchemeContrast` at all — that omission IS the scenario. 3.44:1 in
                    // both states, so a user who turns the setting on to cope gets no change,
                    // and a scan in either state sees the same thing.
                    contrastCard("Ignores Increase Contrast", size: 15,
                                 foreground: "#8A8A8E", background: "#FFFFFF")
                        .srcLine()

                    // 10. 18pt at the default content size, so large text at 3:1 and it clears
                    // that. At xSmall the rendered size drops below 18pt, the threshold becomes
                    // 4.5:1, and the same colour fails.
                    Text("Large at default size, normal text at xSmall")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(Color(hex: "#8E8E93"))
                        .padding(10)
                        .frame(maxWidth: 300, alignment: .leading)
                        .background(Color(hex: "#FFFFFF"))
                        .srcLine()
                }
                .padding()
            }
            .navigationTitle("Composited Contrast (Partial)")
        }
    }
}

#Preview {
    AccessibleTextContrastCompositedPartial()
}
