import SwiftUI

/// MODAL CLOSE — Partial tier.
///
/// One dialog can be closed and one cannot.
///
/// Elements covered (2):
///   1. Save dialog   — Save and Close buttons  → BB40114 Pass
///   2. Rename dialog — Save only               → BB40115 Fail
struct AccessibleModalClosePartial: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Save changes")
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
                        Text("Rename item")
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
            .navigationTitle("ModalClosePartial")
        }
    }
}

#Preview {
    AccessibleModalClosePartial()
}
