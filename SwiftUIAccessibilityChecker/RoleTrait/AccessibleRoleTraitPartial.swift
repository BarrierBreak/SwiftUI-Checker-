import SwiftUI

/// ROLE TRAIT — Partial tier.
///
/// Two native controls are left alone; two have had their role changed.
///
/// Elements covered (4):
///   1. Save       — Button, untouched                        → BB40275 Pass
///   2. Wi-Fi      — Toggle, untouched                        → BB40275 Pass
///   3. Volume     — Slider marked .isButton                  → BB40274 Fail
///   4. Terms      — Link, .isLink removed                    → BB40274 Fail
struct AccessibleRoleTraitPartial: View {
    @State private var wifi = true
    @State private var volume = 0.5

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button("Save") {}
                        .buttonStyle(.borderedProminent)
                        .srcLine()

                    Toggle("Wi-Fi", isOn: $wifi)
                        .srcLine()

                    Slider(value: $volume)
                        .accessibilityLabel("Volume")
                        .accessibilityAddTraits(.isButton)
                        .srcLine()

                    Link("Terms of service", destination: URL(string: "https://example.com/terms")!)
                        .accessibilityRemoveTraits(.isLink)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("RoleTraitPartial")
        }
    }
}

#Preview {
    AccessibleRoleTraitPartial()
}
