import SwiftUI

/// ADJUSTABLE VALUE — Partial tier.
///
/// One adjustable element says where it is set and one does not.
///
/// Elements covered (2):
///   1. Brightness slider — value left to the system                → BB40279 Pass
///   2. Star rating       — adjustable action, no .accessibilityValue → BB40278 Fail
struct AccessibleAdjustableValuePartial: View {
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
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundColor(.orange)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Rating")
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
            .navigationTitle("AdjustableValuePartial")
        }
    }
}

#Preview {
    AccessibleAdjustableValuePartial()
}
