import SwiftUI

/// IMAGES — Fail tier.
///
/// Every picture is exposed to VoiceOver with a "description" that describes nothing. Each
/// reports BB40126 "Non-descriptive textual description provided for image".
///
/// Elements covered (5) — four fail, one is left for a person to judge:
///   1. "image"              — a generic term
///   2. "photo.png"          — a file name
///   3. "IMG_0423"           — an asset name
///   4. "20240915"           — numerals are not judged by wording; BB40045 Validate
///   5. "hero_banner"        — an identifier
struct AccessibleImagesFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Image(systemName: "photo")
                        .accessibilityLabel("image")
                        .srcLine()

                    Image(systemName: "photo.fill")
                        .accessibilityLabel("photo.png")
                        .srcLine()

                    Image(systemName: "camera.fill")
                        .accessibilityLabel("IMG_0423")
                        .srcLine()

                    Image(systemName: "calendar")
                        .accessibilityLabel("20240915")
                        .srcLine()

                    Image(systemName: "rectangle.fill")
                        .accessibilityLabel("hero_banner")
                        .srcLine()
                }
                .font(.largeTitle)
                .padding(24)
            }
            .navigationTitle("Images (Fail)")
        }
    }
}

#Preview {
    AccessibleImagesFail()
}
