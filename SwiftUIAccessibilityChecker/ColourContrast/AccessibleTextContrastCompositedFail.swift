import SwiftUI

/// TEXT CONTRAST — Fail tier, composited and adaptive (WCAG 1.4.3 AA).
///
/// Every scenario is below 3:1 once composited, so nothing here is rescued by a large font or
/// a different threshold. The reason this tier still matters after the solid-background Fail
/// screen is that several of these read as HIGH-contrast pairings in the source: row 1 assigns
/// pure black, row 2 puts white on near-black. A checker that reads assigned colours and never
/// composites reports 21:1 and 17:1 for the two least readable rows on the screen.
///
/// The SwiftUI rule does composite, because it samples the rendered pixels rather than reading
/// properties — so this screen is where the SwiftUI path is STRONGER than its UIKit twin,
/// which reads `textColor` and cannot see view opacity or a material at all. What neither can
/// see is a configuration it is not running in, and rows 8 and 9 are built so that the failure
/// is present in the appearance and contrast setting the scan actually uses. The versions that
/// fail only in the OTHER configuration live on the Partial screen, because "passes in the one
/// configuration you tested" is that tier's whole character.
///
/// Scenarios covered (10):
///   1.  Text opacity 0.35     — effective #A6A6A6 on #FFFFFF → 2.43:1
///   2.  Background opacity 0.4 — #FFFFFF on effective #A4A4A5 → 2.49:1
///   3.  Three stacked layers   — three light layers, text near-invisible
///   4.  Blur material          — #9E9EA3 on a light material → ≈2.4:1
///   5.  Secondary on material  — pale grey sunk further into the material
///   6.  Gradient               — 2.88:1 at one end, 1.90:1 at the other
///   7.  Image, no scrim        — #FFFFFF on #C8D2DC → 1.53:1
///   8.  Dark panel, dark text  — #5A5A5E on #1C1C1E → 2.48:1 in EVERY appearance
///   9.  Increase Contrast      — #B4B4B4 → #C8C8C8: worse with the setting ON
///   10. Dynamic Type           — #7EB8F0 on #FFFFFF → 2.10:1 at every content size
///
/// Scenario 9 is the sharpest failure on the screen: the setting is read correctly and the
/// colour is then moved the WRONG WAY, so enabling the accessibility feature makes the text
/// worse for the user who enabled it. It fails at 2.07:1 with the setting off as well, so the
/// row is a finding in either state rather than only in the one a tester might not try.
///
/// Deliberately broken; reference only.
struct AccessibleTextContrastCompositedFail: View {

    @Environment(\.colorSchemeContrast) private var contrast

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 1. Pure black at 0.35 opacity composites to #A6A6A6 — 2.43:1. The source
                    // says #000000, which is the maximum contrast possible.
                    contrastCard("Text drawn at 35% opacity", size: 17, foreground: "#000000")
                        .opacity(0.35)
                        .srcLine()

                    // 2. A near-black panel at 0.4 composites to #A4A4A5, so white text sits at
                    // 2.49:1. The source pairing computes to 17:1 if the opacity is ignored.
                    contrastCard("White text on a translucent panel", size: 15,
                                 foreground: "#FFFFFF", background: "#1C1C1E", backgroundOpacity: 0.4)
                        .srcLine()

                    // 3. Three stacked light layers over white. Each is nearly transparent, the
                    // composite is barely darker than the page, and white text on it is
                    // effectively invisible.
                    contrastCard("Text over three translucent layers", size: 15,
                                 foreground: "#FFFFFF", background: "#1C1C1E", backgroundOpacity: 0.1)
                        .padding(4)
                        .background(Color(hex: "#FFFFFF").opacity(0.5))
                        .padding(4)
                        .background(Color(hex: "#1C1C1E").opacity(0.15))
                        .srcLine()

                    // 4. Light grey on a light material.
                    materialCard("Text over a blur material", foreground: Color(hex: "#9E9EA3"))
                        .srcLine()

                    // 5. `.secondary` sinks text into its material by design, and starting from
                    // a pale grey sinks it below any usable ratio. The resulting colour is not
                    // knowable from the source at all — it is computed by the renderer from the
                    // material and the backdrop, which is itself the finding: it cannot be
                    // verified statically, only sampled.
                    Text("Secondary style over a material")
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundStyle(.secondary)
                        .foregroundColor(Color(hex: "#C4C4C8"))
                        .padding(10)
                        .frame(maxWidth: 300, alignment: .leading)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                        .srcLine()

                    // 6. A pale gradient — white text runs from 2.88:1 down to 1.90:1, so no
                    // point along the string reaches even the large-text floor.
                    GradientTextCard(text: "Unreadable across the whole gradient",
                                     from: "#3AA0E0", to: "#7FC4F0", textColor: "#FFFFFF")
                        .srcLine()

                    // 7. No scrim at all: white caption directly on a light image — 1.53:1.
                    // This is the single most common contrast failure in shipping apps, because
                    // it is created by swapping a dark hero image for a light one long after
                    // the caption was designed.
                    ScrimmedImageTextCard(text: "Caption over a photo",
                                          imageColor: "#C8D2DC", scrimOpacity: 0.0,
                                          textColor: "#FFFFFF")
                        .srcLine()

                    // 8. One hardcoded dark grey on a near-black panel. 2.48:1, and the value
                    // is fixed, so it fails in light mode and in dark mode alike — no
                    // configuration rescues it.
                    contrastCard("Dark text on a dark panel", size: 15,
                                 foreground: "#5A5A5E", background: "#1C1C1E")
                        .srcLine()

                    // 9. Increase Contrast handled backwards — see the note in the type
                    // comment. 2.07:1 with the setting off, 1.72:1 with it on.
                    contrastCard("Lightens when Increase Contrast is on", size: 15,
                                 foregroundColor: contrast == .increased
                                     ? Color(hex: "#C8C8C8")   // 1.72:1 — worse with it ON
                                     : Color(hex: "#B4B4B4"),  // 2.07:1
                                 background: "#FFFFFF")
                        .srcLine()

                    // 10. Fails at every content size, so there is no configuration in which
                    // this one passes.
                    Text("Fails at every Dynamic Type size")
                        .font(.body)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(hex: "#7EB8F0"))
                        .padding(10)
                        .frame(maxWidth: 300, alignment: .leading)
                        .background(Color(hex: "#FFFFFF"))
                        .srcLine()
                }
                .padding()
            }
            .navigationTitle("Composited Contrast (Fail)")
        }
    }
}

#Preview {
    AccessibleTextContrastCompositedFail()
}
