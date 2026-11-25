import SwiftUI

/// MODAL KEYBOARD — Fail tier.
///
/// Elements covered (1) — a defect:
///   1. Notice — text only, nothing a keyboard can focus  → BB40244 Fail and BB40115 Fail (family modal); nothing in modalKeyboard
struct AccessibleModalKeyboardFail: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
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
            .navigationTitle("ModalKeyboardFail")
        }
    }
}

#Preview {
    AccessibleModalKeyboardFail()
}
