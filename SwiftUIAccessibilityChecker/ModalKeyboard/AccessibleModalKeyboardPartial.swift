import SwiftUI

/// MODAL KEYBOARD — Partial tier.
///
/// Elements covered (2):
///   1. Delete draft — Save and Close buttons                  → BB40245 Pass (family modalKeyboard)
///   2. Notice       — text only, nothing a keyboard can focus  → BB40244 Fail and BB40115 Fail (family modal)
struct AccessibleModalKeyboardPartial: View {
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
                        Text("Notice")
                            .font(.headline)
                        Text("Your draft was shared.")
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.15))
                    .accessibilityAddTraits(.isModal)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("ModalKeyboardPartial")
        }
    }
}

#Preview {
    AccessibleModalKeyboardPartial()
}
