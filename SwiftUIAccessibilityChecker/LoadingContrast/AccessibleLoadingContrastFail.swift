import SwiftUI

/// LOADING CONTRAST — Fail tier.
///
/// Elements covered (2) — both are defects:
///   1. Upload progress   — #CFE3F7 tint (1.3:1)  → BB40064 Fail
///   2. Download progress — #CFE3F7 tint           → BB40064 Fail
struct AccessibleLoadingContrastFail: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ProgressView(value: 0.6)
                        .tint(Color(hex: "#CFE3F7"))
                        .srcLine()

                    ProgressView(value: 0.6)
                        .tint(Color(hex: "#CFE3F7"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("LoadingContrastFail")
        }
    }
}

#Preview {
    AccessibleLoadingContrastFail()
}
