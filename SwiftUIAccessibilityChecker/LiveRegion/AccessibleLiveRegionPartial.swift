import SwiftUI

/// LIVE REGION — Partial tier.
///
/// Elements covered (3):
///   1. "Profile saved"    — .updatesFrequently    → BB40104 Pass (family liveRegion)
///   2. "Upload failed"    — no live-region trait  → BB40103 Fail
///   3. "Account overview" — ordinary text         → no row (not a status message)
struct AccessibleLiveRegionPartial: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Account overview")
                        .font(.headline)

                    Text("Profile saved")
                        .accessibilityAddTraits(.updatesFrequently)
                        .srcLine()

                    Text("Upload failed")
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("LiveRegionPartial")
        }
    }
}

#Preview {
    AccessibleLiveRegionPartial()
}
