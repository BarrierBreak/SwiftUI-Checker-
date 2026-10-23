import SwiftUI

/// ROLE TRAIT — Fail tier.
///
/// Native controls whose role trait has been taken away or replaced, so VoiceOver announces
/// something other than what they are. Judged from source (SWIFTUI_NATIVE_ROLE_MISMATCH).
///
/// Elements covered (5) — every one fails:
///   1. Save       — Button, .isButton removed                → BB40274 Fail
///   2. Wi-Fi      — Toggle, .isToggle removed                → BB40274 Fail
///   3. Volume     — Slider marked .isButton                  → BB40274 Fail
///   4. Name       — TextField marked .isButton               → BB40274 Fail
///   5. Terms      — Link, .isLink removed                    → BB40274 Fail
struct AccessibleRoleTraitFail: View {
    @State private var wifi = true
    @State private var volume = 0.5
    @State private var name = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button("Save") {}
                        .buttonStyle(.borderedProminent)
                        .accessibilityRemoveTraits(.isButton)
                        .srcLine()

                    Toggle("Wi-Fi", isOn: $wifi)
                        .accessibilityRemoveTraits(.isToggle)
                        .srcLine()

                    Slider(value: $volume)
                        .accessibilityLabel("Volume")
                        .accessibilityAddTraits(.isButton)
                        .srcLine()

                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel("Name")
                        .accessibilityAddTraits(.isButton)
                        .srcLine()

                    Link("Terms of service", destination: URL(string: "https://example.com/terms")!)
                        .accessibilityRemoveTraits(.isLink)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("RoleTraitFail")
        }
    }
}

#Preview {
    AccessibleRoleTraitFail()
}
