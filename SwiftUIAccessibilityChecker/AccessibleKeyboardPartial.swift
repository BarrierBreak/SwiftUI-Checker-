import SwiftUI

/// Reachable by Tab (.focusable()), but has no onKeyPress handler — Space does nothing,
/// unlike a tap. Demonstrates "focusable" and "keyboard-operable" as two independently
/// gettable-wrong requirements, the SwiftUI counterpart of the UIKit target's
/// FocusableButNotActivatableChip (canBecomeFocused = true, only .touchUpInside wired).
struct FocusableButNotActivatableChip: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .onTapGesture { isOn.toggle() }
            .focusable()
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(title)
            .accessibilityValue(isOn ? "On" : "Off")
            .srcLine()
    }
}

struct AccessibleKeyboardPartial: View {
    @State private var correctOn = false
    @State private var deadEndOn = false
    @State private var unreachableOn = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Custom controls — mixed keyboard support") {
                    KeyboardAccessibleChip(title: "Focusable and activatable", isOn: $correctOn)
                    FocusableButNotActivatableChip(title: "Focusable, Space does nothing", isOn: $deadEndOn)
                    KeyboardInaccessibleChip(title: "Not Tab-reachable at all", isOn: $unreachableOn)
                }
            }
            .navigationTitle("Accessible Keyboard (Partial)")
        }
    }
}

#Preview {
    AccessibleKeyboardPartial()
}
