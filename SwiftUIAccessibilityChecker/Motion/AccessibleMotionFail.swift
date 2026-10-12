import SwiftUI

/// MOTION — Fail tier.
///
/// Two cards act on a shake and neither offers a way in that works without one. Each reports
/// BB40052 "No On-Screen Alternative for Motion Action".
///
/// Elements covered (2) — both fail:
///   1. Refresh card  — shake to refresh, and nothing else on the card
///   2. Shuffle card  — shake to shuffle, with a Shuffle button marked
///                      `.accessibilityHidden(true)`, so VoiceOver cannot reach it and it is
///                      not an alternative
struct AccessibleMotionFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shake your phone to refresh the feed")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .onShake {}

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shake your phone to shuffle the playlist")
                        Button("Shuffle") {}
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .onShake {}
                }
                .padding(24)
            }
            .navigationTitle("Motion (Fail)")
        }
    }
}

#Preview {
    AccessibleMotionFail()
}
