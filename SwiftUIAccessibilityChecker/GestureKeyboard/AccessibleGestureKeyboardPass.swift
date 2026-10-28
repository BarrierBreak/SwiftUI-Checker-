import SwiftUI

/// GESTURE KEYBOARD — Pass tier.
///
/// Both tap-driven cards declare a button and offer an accessibility action.
///
/// Elements covered (2):
///   1. Profile card  — onTapGesture + .isButton + accessibilityAction  → BB40072 Pass
///   2. Settings card — onTapGesture + .isButton + accessibilityAction  → BB40072 Pass
struct AccessibleGestureKeyboardPass: View {
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
                    .accessibilityAction(named: "Open") { tapped += 1 }
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("GestureKeyboardPass")
        }
    }
}

#Preview {
    AccessibleGestureKeyboardPass()
}
