import SwiftUI

/// LIVE REGION — Pass tier.
///
/// Elements covered (3) — none is a defect:
///   1. "Profile saved"    — .updatesFrequently  → BB40104 Pass (family liveRegion)
///   2. "Upload complete"  — .updatesFrequently  → BB40104 Pass
///   3. "Account overview" — ordinary text       → no row (not a status message)
struct AccessibleLiveRegionPass: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Account overview")
                        .font(.headline)

                    Text("Profile saved")
                        .accessibilityAddTraits(.updatesFrequently)
                        .srcLine()

                    Text("Upload complete")
                        .accessibilityAddTraits(.updatesFrequently)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("LiveRegionPass")
        }
    }
}

#Preview {
    AccessibleLiveRegionPass()
}
