import SwiftUI

/// LIVE REGION — Fail tier.
///
/// Elements covered (3):
///   1. "Upload failed"    — no live-region trait  → BB40103 Fail (family liveRegion)
///   2. "Changes saved"    — no live-region trait  → BB40103 Fail
///   3. "Account overview" — ordinary text         → no row (not a status message)
struct AccessibleLiveRegionFail: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Account overview")
                        .font(.headline)

                    Text("Upload failed")
                        .srcLine()

                    Text("Changes saved")
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("LiveRegionFail")
        }
    }
}

#Preview {
    AccessibleLiveRegionFail()
}
