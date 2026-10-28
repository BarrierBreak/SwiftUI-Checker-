import SwiftUI

/// GESTURE KEYBOARD — Partial tier.
///
/// One card has an accessibility action and one does not.
///
/// Elements covered (2):
///   1. Profile card  — onTapGesture + .isButton + accessibilityAction  → BB40072 Pass
///   2. Settings card — onTapGesture + .isButton, no action             → BB40071 Fail
struct AccessibleGestureKeyboardPartial: View {
    @State private var tapped = 0
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Profile")
                            .font(.headline)
                        Text("Tap to open")
                            .font(.subheadline)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.15))
                    .onTapGesture { tapped += 1 }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAction(named: "Open") { tapped += 1 }
                    .srcLine()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Settings")
                            .font(.headline)
                        Text("Tap to open")
                            .font(.subheadline)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.15))
                    .onTapGesture { tapped += 1 }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("GestureKeyboardPartial")
        }
    }
}

#Preview {
    AccessibleGestureKeyboardPartial()
}
