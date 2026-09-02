import SwiftUI

/// SwiftUI text has no exposed UIColor, so ColorContrastValidator's SwiftUI path renders the
/// screen to an image and samples pixels behind each text element instead of reading a
/// background color directly. The UIKit screen has a dedicated BB40514 "Validate" record for
/// text over an image/gradient ancestor; the SwiftUI path never inspects ancestry at all, so
/// there's no equivalent record here — it just samples whatever pixels happen to sit behind
/// the text. Over a gradient, that sampled contrast genuinely depends on which strip of the
/// gradient sits behind the text, so whatever verdict the sampler reaches is only as reliable
/// as the crop it happened to take: a case for a person to double-check, not a broken or
/// well-behaved control like the other Partial screens demonstrate.
struct AccessibleColorContrastPartial: View {
    var body: some View {
        NavigationStack {
            // Plain ScrollView/VStack, not Form — see AccessibleColorContrastPass.swift's
            // contrastText doc comment: a full-width, >40pt-tall element reads as a
            // decorative container to validateSwiftUIContrast and gets skipped before any
            // pixel sampling happens, which would silently drop these cards from the report
            // entirely instead of demonstrating an unreliable-but-present verdict.
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Text over a gradient background — automated contrast sampling is unreliable here")
                        .font(.headline)

                    // Short, single-line text — see AccessibleColorContrastPass.swift's
                    // contrastText doc comment: wrapped multi-line text over 60pt tall gets
                    // center-cropped to a band that can miss the text glyphs entirely.
                    ZStack {
                        LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                        Text("Blue-purple gradient")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(width: 220, height: 50)
                    .cornerRadius(10)
                    .srcLine()

                    ZStack {
                        LinearGradient(colors: [.black, .white], startPoint: .leading, endPoint: .trailing)
                        Text("Black-white gradient")
                            .foregroundColor(.black)
                            .padding()
                    }
                    .frame(width: 220, height: 50)
                    .cornerRadius(10)
                    .srcLine()
                }
                .padding()
            }
            .navigationTitle("Accessible Color Contrast (Partial)")
        }
    }
}

#Preview {
    AccessibleColorContrastPartial()
}
