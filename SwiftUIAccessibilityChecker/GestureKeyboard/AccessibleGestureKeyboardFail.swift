import SwiftUI

/// GESTURE KEYBOARD — Fail tier.
///
/// Both tap-driven cards declare a button but only a touch can activate them.
///
/// Elements covered (2):
///   1. Profile card  — onTapGesture + .isButton, no action  → BB40071 Fail
///   2. Settings card — onTapGesture + .isButton, no action  → BB40071 Fail
struct AccessibleGestureKeyboardFail: View {
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
            .navigationTitle("GestureKeyboardFail")
        }
    }
}

#Preview {
    AccessibleGestureKeyboardFail()
}
