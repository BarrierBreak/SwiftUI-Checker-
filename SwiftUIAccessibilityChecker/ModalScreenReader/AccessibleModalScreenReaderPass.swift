import SwiftUI

/// MODAL SCREEN READER — Pass tier.
///
/// Elements covered (2) — none is a defect:
///   1. Delete draft — Save and Close buttons                  → BB40116 Pass (family modalScreenReader)
///   2. Share draft  — Save only, but an escape action          → BB40116 Pass
struct AccessibleModalScreenReaderPass: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Delete draft")
                            .font(.headline)
                        Button("Save") {}
                        Button("Close") {}
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.15))
                    .accessibilityAddTraits(.isModal)
                    .srcLine()

                    VStack(spacing: 12) {
                        Text("Share draft")
                            .font(.headline)
                        Button("Save") {}
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.15))
                    .accessibilityAddTraits(.isModal)
                    .accessibilityAction(.escape) {}
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("ModalScreenReaderPass")
        }
    }
}

#Preview {
    AccessibleModalScreenReaderPass()
}
