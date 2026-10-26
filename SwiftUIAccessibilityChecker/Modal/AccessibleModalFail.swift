import SwiftUI

/// MODAL — Fail tier.
///
/// Two dialogs are marked `.isModal`:
///   BB40244  "Modal has no keyboard-focusable interactive controls"
///   BB40115  "Modal dialog inaccessible for screen reader users"
///
/// SwiftUI gives a modal no runtime marker a scan can read, so these are decided from the
/// source — see source_role_linter.py, check_swiftui_batch2_rules.
///
/// Elements covered (2):
///   1. Session expired — nothing to operate and no way out   → BB40244 and BB40115
///   2. Remember choice — controls, but no dismiss or escape  → BB40115
struct AccessibleModalFail: View {
    @State private var remember = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Session expired")
                            .font(.headline)
                        Text("Your session has expired. Please wait.")
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
            .navigationTitle("ModalFail")
        }
    }
}

#Preview {
    AccessibleModalFail()
}
