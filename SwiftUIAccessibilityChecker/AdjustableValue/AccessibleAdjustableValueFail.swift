import SwiftUI

/// ADJUSTABLE VALUE — Fail tier.
///
/// No adjustable element says where it is set.
///
/// Elements covered (2) — every one is a defect:
///   1. Volume slider — .accessibilityValue("") blanks the system value  → BB40278 Fail
///   2. Star rating   — adjustable action, no .accessibilityValue        → BB40278 Fail
struct AccessibleAdjustableValueFail: View {
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
                    Slider(value: $volume, in: 0...100)
                        .accessibilityLabel("Volume")
                        .accessibilityValue("")
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
            .navigationTitle("AdjustableValueFail")
        }
    }
}

#Preview {
    AccessibleAdjustableValueFail()
}
