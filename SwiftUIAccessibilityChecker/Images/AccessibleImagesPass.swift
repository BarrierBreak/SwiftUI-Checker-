import SwiftUI

/// IMAGES — Pass tier.
///
/// Every informative picture has a real description, and the decoration is kept out of the
/// accessibility tree. Each described picture reports BB40045 "Check if image has correct
/// textual description" — a Validate row, because only a person looking at the picture can say
/// the words are the right ones. The decoration reports nothing.
///
/// Elements covered (6):
///   1. Star rating     — "Five-star rating"                          → BB40045
///   2. Weather         — "Sunny with a light breeze, 22 degrees"     → BB40045
///   3. Profile photo   — "Profile photo of Alex Morgan"              → BB40045
///   4. Map pin         — "Map pin marking the cafe entrance"         → BB40045
///   5. Sparkles        — decoration, `.accessibilityHidden(true)`    → not reported
///   6. Divider         — decoration, `.accessibilityHidden(true)`    → not reported
struct AccessibleImagesPass: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Image(systemName: "star.fill")
                        .accessibilityLabel("Five-star rating")
                        .srcLine()

                    Image(systemName: "cloud.sun.fill")
                        .accessibilityLabel("Sunny with a light breeze, 22 degrees")
                        .srcLine()

                    Image(systemName: "person.crop.circle")
                        .accessibilityLabel("Profile photo of Alex Morgan")
                        .srcLine()

                    Image(systemName: "mappin.circle")
                        .accessibilityLabel("Map pin marking the cafe entrance")
                        .srcLine()

                    Image(systemName: "sparkles")
                        .accessibilityHidden(true)
                        .srcLine()

                    Image(systemName: "line.horizontal.3")
                        .accessibilityHidden(true)
                        .srcLine()
                }
                .font(.largeTitle)
                .padding(24)
            }
            .navigationTitle("Images (Pass)")
        }
    }
}

#Preview {
    AccessibleImagesPass()
}
