import SwiftUI

/// ADJUSTABLE VALUE — Pass tier.
///
/// Every adjustable element says where it is set.
///
/// Elements covered (3) — none is a defect:
///   1. Brightness slider — value left to the system ("60%")            → BB40279 Pass
///   2. Volume slider     — .accessibilityValue("40 percent")          → BB40279 Pass
///   3. Star rating       — adjustable action + .accessibilityValue    → BB40279 Pass
struct AccessibleAdjustableValuePass: View {
    @State private var brightness = 60.0
    @State private var volume = 40.0
    @State private var rating = 3

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Settings")
                        .font(.headline)
                        .srcLine()
                    Slider(value: $brightness, in: 0...100)
                        .accessibilityLabel("Brightness")
                        .srcLine()
                    Slider(value: $volume, in: 0...100)
                        .accessibilityLabel("Volume")
                        .accessibilityValue("\(Int(volume)) percent")
                        .srcLine()
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundColor(.orange)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Rating")
                    .accessibilityValue("\(rating) of 5 stars")
                    .accessibilityAdjustableAction { direction in
                        switch direction {
                        case .increment: rating = min(rating + 1, 5)
                        case .decrement: rating = max(rating - 1, 1)
                        @unknown default: break
                        }
                    }
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("AdjustableValuePass")
        }
    }
}

#Preview {
    AccessibleAdjustableValuePass()
}
