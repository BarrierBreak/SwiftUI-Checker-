import SwiftUI

/// ColorContrastValidator's SwiftUI path can't read a Color directly — it renders the screen
/// to an image and clusters sampled pixels, then takes the LIGHTEST 20% of the "dark" cluster
/// as the foreground (worst-case, to catch weak sub-text inside a merged element). Three
/// things get in the way of that landing on a genuine reading for a short card like this one:
/// a Form row's own material never composites a pure white background (measured #FDFDFD, not
/// #FFFFFF, even under an explicit .background(.white)); a `.frame(maxWidth: .infinity)` card
/// reads as a decorative container (wider than 95% of the screen, taller than 40pt) and gets
/// skipped before any pixel sampling happens at all; and long descriptive text wrapped across
/// several lines pushes the element past 60pt tall, which crops the analysis to the vertical
/// middle 40% — a band that can land entirely on inter-line whitespace instead of any glyph.
/// Plain ScrollView/VStack, natural (unconstrained) width, and short, single-line text avoid
/// all three: the card sizes to its short content, stays under the container-width threshold,
/// and stays under 60pt tall so the full element — not a cropped slice of it — gets sampled.
private func contrastText(_ text: String, size: CGFloat) -> some View {
    Text(text)
        .foregroundColor(.black)
        .font(.system(size: size, weight: .heavy))
        .padding(10)
        .frame(maxWidth: 260, alignment: .leading)
        .background(Color.white)
}

struct AccessibleColorContrastPass: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("High-contrast text — passes WCAG AA")
                        .font(.headline)

                    // .srcLine() is applied per call site, not inside a shared helper, so
                    // each card gets its own distinct "src:file:line" identifier — sharing
                    // one line between both cards let the second finding collapse into the
                    // first in the report.
                    contrastText(
                        "Black text on white — above the 4.5:1 normal-text AA threshold.",
                        size: 15
                    )
                    .srcLine()

                    contrastText(
                        "Black text on white — above the 3:1 large-text AA threshold.",
                        size: 22
                    )
                    .srcLine()
                }
                .padding()
            }
            .navigationTitle("Accessible Color Contrast (Pass)")
        }
    }
}

#Preview {
    AccessibleColorContrastPass()
}
