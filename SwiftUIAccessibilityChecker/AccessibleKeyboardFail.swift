import SwiftUI

/// Same visual chip as AccessibleKeyboardPass, but deliberately missing .focusable() — so
/// it's reachable by touch and VoiceOver (it still carries .isButton), but invisible to
/// hardware-keyboard Tab navigation.
struct KeyboardInaccessibleChip: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .onTapGesture { isOn.toggle() }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(title)
            .accessibilityValue(isOn ? "On" : "Off")
            .srcLine()
    }
}

struct AccessibleKeyboardFail: View {
    @State private var favoriteOn = false
    @State private var notificationsOn = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Custom controls — touch-only, not keyboard-focusable") {
                    KeyboardInaccessibleChip(title: "Add to favorites", isOn: $favoriteOn)
                    KeyboardInaccessibleChip(title: "Enable notifications", isOn: $notificationsOn)
                }
            }
            .navigationTitle("Accessible Keyboard (Fail)")
        }
    }
}

#Preview {
    AccessibleKeyboardFail()
}
