import SwiftUI

/// IMAGES — Partial tier.
///
/// A mix: some pictures are described well, some are exposed with no description, and one
/// has a description that is not one.
///
/// Elements covered (5):
///   1. Star rating     — "Five-star rating"                    → BB40045 Validate
///   2. Profile photo   — "Profile photo of Alex Morgan"        → BB40045 Validate
///   3. Placeholder     — exposed, empty description            → BB40044 Validate
///   4. Banner          — exposed, no description               → BB40044 Validate
///   5. Header image    — "image"                               → BB40126 Fail
struct AccessibleImagesPartial: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Image(systemName: "star.fill")
                        .accessibilityLabel("Five-star rating")
                        .srcLine()

                    Image(systemName: "person.crop.circle")
                        .accessibilityLabel("Profile photo of Alex Morgan")
                        .srcLine()

                    // Exposed, but the description is empty.
                    Image(systemName: "photo")
                        .accessibilityLabel("")
                        .srcLine()

                    // A picture with no symbol name to fall back on and no description.
                    Image(uiImage: Self.blank)
                        .resizable()
                        .frame(width: 56, height: 56)
                        .srcLine()

                    Image(systemName: "photo.fill")
                        .accessibilityLabel("image")
                        .srcLine()
                }
                .font(.largeTitle)
                .padding(24)
            }
            .navigationTitle("Images (Partial)")
        }
    }

    private static let blank: UIImage = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { context in
        UIColor.systemGray4.setFill()
        context.fill(CGRect(x: 0, y: 0, width: 20, height: 20))
    }
}

#Preview {
    AccessibleImagesPartial()
}
