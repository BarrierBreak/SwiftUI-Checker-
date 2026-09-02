import SwiftUI

// See AccessibleColorContrastPass.swift's contrastText doc comment: a Form row never
// composites a pure white background, a full-width card gets misread as a decorative
// container and skipped, and wrapped multi-line text gets center-cropped to a band that can
// miss every glyph. Fixed the same way here — plain ScrollView/VStack, natural width, short
// single-line text — plus both greys are chosen to fail even the more lenient 3:1 large-text
// threshold, so the demo doesn't depend on which threshold the runtime ends up applying.
private func contrastText(_ text: String, textColor: Color, size: CGFloat) -> some View {
    Text(text)
        .foregroundColor(textColor)
        .font(.system(size: size, weight: .heavy))
        .padding(10)
        .frame(maxWidth: 260, alignment: .leading)
        .background(Color.white)
}

struct AccessibleColorContrastFail: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Low-contrast text — fails WCAG AA")
                        .font(.headline)

                    // white:0.7 on white ≈ 2.1:1 — fails even the lenient 3:1 threshold.
                    contrastText(
                        "Grey text on white — fails the 4.5:1 AA threshold for normal text.",
                        textColor: Color(white: 0.7),
                        size: 15
                    )
                    .srcLine()

                    // white:0.85 on white ≈ 1.4:1 — fails even the lenient 3:1 threshold.
                    contrastText(
                        "Near-white text on white — fails even the 3:1 large-text threshold.",
                        textColor: Color(white: 0.85),
                        size: 22
                    )
                    .srcLine()
                }
                .padding()
            }
            .navigationTitle("Accessible Color Contrast (Fail)")
        }
    }
}

#Preview {
    AccessibleColorContrastFail()
}
