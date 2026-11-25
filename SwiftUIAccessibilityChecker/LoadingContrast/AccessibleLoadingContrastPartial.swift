import SwiftUI

/// LOADING CONTRAST — Partial tier.
///
/// Elements covered (2):
///   1. Upload progress   — #CFE3F7 tint (1.3:1)  → BB40064 Fail
///   2. Download progress — #1F2A44 tint           → BB40065 Pass
struct AccessibleLoadingContrastPartial: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ProgressView(value: 0.6)
                        .tint(Color(hex: "#CFE3F7"))
                        .srcLine()

                    ProgressView(value: 0.6)
                        .tint(Color(hex: "#1F2A44"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("LoadingContrastPartial")
        }
    }
}

#Preview {
    AccessibleLoadingContrastPartial()
}
