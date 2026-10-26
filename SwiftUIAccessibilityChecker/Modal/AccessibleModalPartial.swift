import SwiftUI

/// MODAL — Partial tier.
///
/// One dialog is complete and one has controls but no way out.
///
/// Elements covered (2):
///   1. Discard dialog  — Discard and Close buttons          → no row
///   2. Remember choice — controls, no dismiss or escape     → BB40115 Fail
struct AccessibleModalPartial: View {
    @State private var remember = false
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

                    VStack(spacing: 12) {
                        Text("Remember choice")
                            .font(.headline)
                        Toggle("Remember my choice", isOn: $remember)
                        Button("Confirm") {}
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.15))
                    .accessibilityAddTraits(.isModal)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("ModalPartial")
        }
    }
}

#Preview {
    AccessibleModalPartial()
}
