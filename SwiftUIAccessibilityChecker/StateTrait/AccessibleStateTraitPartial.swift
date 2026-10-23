import SwiftUI

/// STATE TRAIT — Partial tier.
///
/// One control reports its state through SwiftUI; one only looks unavailable.
///
/// Elements covered (2):
///   1. Notifications — Toggle(isOn:)                    → BB40277 Pass
///   2. Submit        — dimmed with opacity, not disabled → no BB40277 row
struct AccessibleStateTraitPartial: View {
    @State private var notifications = true
    @State private var ready = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Toggle("Notifications", isOn: $notifications)
                        .srcLine()

                    Button("Submit") {}
                        .buttonStyle(.borderedProminent)
                        .opacity(ready ? 1 : 0.4)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("StateTraitPartial")
        }
    }
}

#Preview {
    AccessibleStateTraitPartial()
}
