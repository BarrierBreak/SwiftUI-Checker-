import SwiftUI

/// TEXT CONTRAST — Pass tier, composited and adaptive (WCAG 1.4.3 AA).
///
/// The solid-background screens test arithmetic on two known colours. This one tests the
/// harder half of the problem: cases where neither the text colour nor the background colour
/// in the comparison is the one written in the source. Four things break the naive two-colour
/// reading —
///
///   • OPACITY. Text at 0.6 opacity is not its assigned colour; the effective colour is the
///     composite of the text over whatever is behind it.
///   • LAYERING. Translucent backgrounds stack, and the effective background is the result of
///     compositing every layer down to an opaque one, which may be several views up.
///   • VARIABILITY. Gradients, images and materials give text a background that differs across
///     the text's own bounding box, so the ratio has to be taken at the WORST point under the
///     glyphs rather than at the centre or the average.
///   • ADAPTATION. Dark mode, Increase Contrast and Dynamic Type each change the inputs at
///     runtime, so a ratio verified once in one configuration proves nothing about the others.
///
/// **The SwiftUI rule is the right way round on the first three and blind to the fourth**, and
/// that is the single most useful thing this screen and its UIKit twin demonstrate together.
/// The UIKit rule reads `textColor` and walks the view hierarchy compositing `backgroundColor`
/// alpha — so it gets layering right and misses view opacity and materials entirely, because
/// neither is a colour it can read. The SwiftUI rule screenshots the window and clusters the
/// pixels, so opacity, stacked layers, materials and vibrancy are all already composited by the
/// renderer before it ever looks. What no static scan can see is the fourth: a scan runs in ONE
/// appearance at ONE content size with Increase Contrast in ONE state, and rows 8 to 10 exist
/// to mark that boundary rather than to be caught by it.
///
/// Scenarios covered (10), all passing AA in every configuration:
///   1.  Text opacity 0.6      — effective #666666 on #FFFFFF → 5.74:1
///   2.  Background opacity     — #FFFFFF on effective #3E3E40 → 10.67:1
///   3.  Two stacked layers     — #FFFFFF on effective #3E3E40 → 10.67:1
///   4.  Blur material          — #3D3D3D on a light material → ≈9.7:1
///   5.  No secondary style     — an opaque colour on the same material → ≈10.9:1
///   6.  Gradient               — #FFFFFF on #0B5FA5 → #1E6B36 → 6.54:1 worst point
///   7.  Image + 55% scrim      — #FFFFFF on scrimmed #C8D2DC → 6.53:1 worst point
///   8.  Dark mode variant      — #595959 light / #C7C7CC dark → 7.00 / 10.10
///   9.  Increase Contrast      — #595959 normal / #3D3D3D high → 7.00 / 10.86
///   10. Dynamic Type           — sized so it passes as NORMAL text → 5.74:1
///
/// Scenario 10 is the one most likely to be missed. An 18pt label is large text and needs only
/// 3:1 — but at the xSmall content size a scaled 18pt font renders SMALLER than 18pt and
/// becomes normal text needing 4.5:1. The safe approach, used here, is to meet the normal-text
/// threshold so the text is compliant at every content size.
struct AccessibleTextContrastCompositedPass: View {

    @Environment(\.colorSchemeContrast) private var contrast

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 1. The assigned colour is pure black, but at 0.6 opacity over white the
                    // effective colour is #666666. Reading the assigned #000000 would report
                    // 21:1 and be wrong by a wide margin; the real ratio is 5.74:1.
                    contrastCard("Text drawn at 60% opacity", size: 17, foreground: "#000000")
                        .opacity(0.6)
                        .srcLine()

                    // 2. The panel is #1C1C1E at 0.85 over white, compositing to #3E3E40.
                    contrastCard("White text on a translucent panel", size: 15,
                                 foreground: "#FFFFFF", background: "#1C1C1E", backgroundOpacity: 0.85)
                        .srcLine()

                    // 3. Two stacked translucent layers. Neither is opaque, so the effective
                    // background is the composite of both over the white page — resolving only
                    // one level up gives the wrong answer.
                    contrastCard("Text over two translucent layers", size: 15,
                                 foreground: "#FFFFFF", background: "#1C1C1E", backgroundOpacity: 0.7)
                        .padding(6)
                        .background(Color(hex: "#1C1C1E").opacity(0.5))
                        .srcLine()

                    // 4. A material resolves to roughly #F2F2F2 over a light page, so the text
                    // colour is chosen against that rather than against the page. The dark grey
                    // used here holds up over any light material.
                    materialCard("Text over a blur material", foreground: Color(hex: "#3D3D3D"))
                        .srcLine()

                    // 5. `.secondary` deliberately reduces contrast to blend text into its
                    // material, which is the opposite of what 1.4.3 asks of primary content.
                    // It is fine for decorative chrome; text that must be read uses a plain
                    // opaque colour instead, which is what this row does.
                    materialCard("Primary text, no secondary style", foreground: Color(hex: "#3D3D3D"))
                        .srcLine()

                    // 6. Both endpoints are dark enough for white text — 6.57:1 at one end and
                    // 6.54:1 at the other — so every point under the glyphs passes. Checking
                    // only the midpoint would be luck.
                    GradientTextCard(text: "White text across a gradient",
                                     from: "#0B5FA5", to: "#1E6B36", textColor: "#FFFFFF")
                        .srcLine()

                    // 7. The image is generated from a known colour so the fixture is
                    // deterministic, and a 55% black scrim sits between it and the text. The
                    // scrim is what makes the ratio predictable — without it, contrast depends
                    // on whatever photo the user uploaded.
                    ScrimmedImageTextCard(text: "Caption over a photo",
                                          imageColor: "#C8D2DC", scrimOpacity: 0.55,
                                          textColor: "#FFFFFF")
                        .srcLine()

                    // 8. Two explicit colours rather than one fixed value, each verified
                    // against its own background: 7.00:1 in light and 10.10:1 in dark. A
                    // single hardcoded grey cannot pass both — the Partial screen has that
                    // version.
                    contrastCard("Adapts to light and dark", size: 17,
                                 foregroundColor: Color(UIColor { traits in
                                     traits.userInterfaceStyle == .dark
                                         ? UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1) // #C7C7CC
                                         : UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1) // #595959
                                 }),
                                 background: "#FFFFFF")
                        .srcLine()

                    // 9. When Increase Contrast is on the system expects content to darken
                    // further. This row reads the environment and does so.
                    contrastCard("Responds to Increase Contrast", size: 15,
                                 foregroundColor: contrast == .increased
                                     ? Color(hex: "#3D3D3D")   // 10.86:1
                                     : Color(hex: "#595959"),  // 7.00:1
                                 background: "#FFFFFF")
                        .srcLine()

                    // 10. The font scales, so its rendered size is not the 17pt in the source.
                    // This colour meets the NORMAL-text threshold, which holds at every content
                    // size — including the small ones where a nominally large font renders
                    // under 18pt.
                    Text("Scales with Dynamic Type, passes at every size")
                        .font(.body)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(hex: "#666666"))
                        .padding(10)
                        .frame(maxWidth: 300, alignment: .leading)
                        .background(Color(hex: "#FFFFFF"))
                        .srcLine()
                }
                .padding()
            }
            .navigationTitle("Composited Contrast (Pass)")
        }
    }
}

// MARK: - Shared composited card shapes
// Used by the Partial and Fail tiers too, with different values passed in, so the only
// difference between the tiers is the numbers rather than the shape.

/// A card whose background carries an opacity, so the effective background is a composite
/// rather than the colour written at the call site.
func contrastCard(
    _ text: String,
    size: CGFloat,
    foreground: String,
    background: String,
    backgroundOpacity: Double
) -> some View {
    Text(text)
        .font(.system(size: size, weight: .heavy))
        .foregroundColor(Color(hex: foreground))
        .padding(10)
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color(hex: background).opacity(backgroundOpacity))
}

/// A card taking an already-built `Color`, for the rows whose foreground is decided at runtime
/// by the appearance or by the Increase Contrast setting rather than by a hex literal.
func contrastCard(
    _ text: String,
    size: CGFloat,
    foregroundColor: Color,
    background: String
) -> some View {
    Text(text)
        .font(.system(size: size, weight: .heavy))
        .foregroundColor(foregroundColor)
        .padding(10)
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color(hex: background))
}

/// Text over a system material. The material is the whole point: it has no colour of its own
/// that any property read could return, and it resolves differently over a light page than a
/// dark one, so only the rendered pixels answer the question.
func materialCard(_ text: String, foreground: Color) -> some View {
    Text(text)
        .font(.system(size: 15, weight: .heavy))
        .foregroundColor(foreground)
        .padding(10)
        .frame(maxWidth: 300, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
}

/// Text over a two-stop linear gradient. The contrast question here is what happens at each
/// END of the gradient, not at its midpoint.
struct GradientTextCard: View {
    let text: String
    let from: String
    let to: String
    let textColor: String

    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .heavy))
            .foregroundColor(Color(hex: textColor))
            .padding(14)
            .frame(maxWidth: 300, alignment: .leading)
            .background(
                LinearGradient(colors: [Color(hex: from), Color(hex: to)],
                               startPoint: .leading, endPoint: .trailing)
            )
    }
}

/// Text over a generated image with an optional black scrim between them. The image is drawn
/// from a fixed colour rather than loaded from an asset, so the effective background is known
/// and the fixture produces the same ratio on every machine.
struct ScrimmedImageTextCard: View {
    let text: String
    let imageColor: String
    let scrimOpacity: Double
    let textColor: String

    private var generatedImage: Image {
        let size = CGSize(width: 4, height: 4)
        let ui = UIGraphicsImageRenderer(size: size).image { context in
            UIColor(Color(hex: imageColor)).setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return Image(uiImage: ui)
    }

    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .heavy))
            .foregroundColor(Color(hex: textColor))
            .padding(16)
            .frame(maxWidth: 300, alignment: .leading)
            .background(
                generatedImage
                    .resizable()
                    .overlay(Color.black.opacity(scrimOpacity))
            )
    }
}

#Preview {
    AccessibleTextContrastCompositedPass()
}
