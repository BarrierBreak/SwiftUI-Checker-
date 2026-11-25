import SwiftUI

/// LOADING CONTRAST — Pass tier.
///
/// Elements covered (2) — none is a defect:
///   1. Upload progress   — #1F2A44 tint (about 14:1)  → BB40065 Pass (family nonTextContrast)
///   2. Download progress — #1F2A44 tint                → BB40065 Pass
struct AccessibleLoadingContrastPass: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ProgressView(value: 0.6)
                        .tint(Color(hex: "#1F2A44"))
                        .srcLine()

                    ProgressView(value: 0.6)
                        .tint(Color(hex: "#1F2A44"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("LoadingContrastPass")
        }
    }
}

#Preview {
    AccessibleLoadingContrastPass()
}
