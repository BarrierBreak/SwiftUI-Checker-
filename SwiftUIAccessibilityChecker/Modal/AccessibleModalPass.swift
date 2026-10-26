import SwiftUI

/// MODAL — Pass tier.
///
/// The dialog is marked `.isModal`, has controls, and has a Close button. Nothing is reported.
///
/// Elements covered (1) — not reported:
///   1. Discard dialog — Discard and Close buttons
struct AccessibleModalPass: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Discard draft")
                            .font(.headline)
                        Text("Discard the draft?")
                        Button("Discard") {}
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
            .navigationTitle("ModalPass")
        }
    }
}

#Preview {
    AccessibleModalPass()
}
