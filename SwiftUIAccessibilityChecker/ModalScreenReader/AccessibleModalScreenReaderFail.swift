import SwiftUI

/// MODAL SCREEN READER — Fail tier.
///
/// Elements covered (1) — a defect:
///   1. Share draft — Save only, no Close, no escape  → BB40115 Fail (family modal); nothing in modalScreenReader
struct AccessibleModalScreenReaderFail: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Share draft")
                            .font(.headline)
                        Button("Save") {}
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.15))
                    .accessibilityAddTraits(.isModal)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("ModalScreenReaderFail")
        }
    }
}

#Preview {
    AccessibleModalScreenReaderFail()
}
