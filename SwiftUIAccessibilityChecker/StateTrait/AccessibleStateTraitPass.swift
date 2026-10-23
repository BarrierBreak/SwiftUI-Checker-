import SwiftUI

/// STATE TRAIT — Pass tier.
///
/// Native controls that let SwiftUI report their state: a Toggle reports on/off, and `.disabled`
/// gives a control the dimmed trait. Judged from source (SWIFTUI_NATIVE_STATE_OK).
///
/// Elements covered (3) — every one passes:
///   1. Notifications — Toggle(isOn:)                  → BB40277 Pass
///   2. Submit        — Button with .disabled(true)    → BB40277 Pass
///   3. Nickname      — TextField with .disabled(true) → BB40277 Pass
struct AccessibleStateTraitPass: View {
    @State private var notifications = true
    @State private var nickname = "Locked"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Toggle("Notifications", isOn: $notifications)
                        .srcLine()

                    Button("Submit") {}
                        .buttonStyle(.borderedProminent)
                        .disabled(true)
                        .srcLine()

                    TextField("Nickname", text: $nickname)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel("Nickname")
                        .disabled(true)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("StateTraitPass")
        }
    }
}

#Preview {
    AccessibleStateTraitPass()
}
