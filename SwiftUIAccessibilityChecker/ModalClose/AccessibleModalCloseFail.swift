import SwiftUI

/// MODAL CLOSE — Fail tier.
///
/// The dialog has a Save button and no way out.
///
/// Elements covered (1):
///   1. Save dialog — Save only, no dismiss or escape  → BB40115 Fail (family modal); nothing in family modalClose
struct AccessibleModalCloseFail: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Save changes")
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
            .navigationTitle("ModalCloseFail")
        }
    }
}

#Preview {
    AccessibleModalCloseFail()
}
