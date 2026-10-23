import SwiftUI

/// ROLE TRAIT — Pass tier.
///
/// Native controls left exactly as SwiftUI makes them, so each keeps the role trait that matches
/// what it is. Judged from source (source_role_linter.py, SWIFTUI_NATIVE_ROLE_OK).
///
/// Elements covered (5) — every one passes:
///   1. Save       — Button                        → BB40275 Pass
///   2. Wi-Fi      — Toggle                        → BB40275 Pass
///   3. Volume     — Slider                        → BB40275 Pass
///   4. Quantity   — Stepper                       → BB40275 Pass
///   5. Terms      — Link                          → BB40275 Pass
struct AccessibleRoleTraitPass: View {
    @State private var wifi = true
    @State private var volume = 0.5
    @State private var quantity = 1

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
                        .srcLine()

                    Stepper("Quantity: \(quantity)", value: $quantity)
                        .srcLine()

                    Link("Terms of service", destination: URL(string: "https://example.com/terms")!)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("RoleTraitPass")
        }
    }
}

#Preview {
    AccessibleRoleTraitPass()
}
