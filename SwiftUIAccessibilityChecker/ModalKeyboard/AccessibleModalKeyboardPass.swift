import SwiftUI

/// MODAL KEYBOARD — Pass tier.
///
/// Elements covered (1) — none is a defect:
///   1. Delete draft — Save and Close buttons  → BB40245 Pass (family modalKeyboard); nothing in family modal
struct AccessibleModalKeyboardPass: View {
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
                }
                .padding(24)
            }
            .navigationTitle("ModalKeyboardPass")
        }
    }
}

#Preview {
    AccessibleModalKeyboardPass()
}
