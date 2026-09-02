import SwiftUI

/// A custom "chip" control that correctly opts into hardware-keyboard focus and
/// activation: .focusable() puts it in the Tab focus loop, and onKeyPress(.space)/
/// onKeyPress(.return) fire the same action a tap does. .focusable() alone only grants
/// focus — SwiftUI does not automatically wire Select/Space to onTapGesture, so the
/// onKeyPress handlers are what make this genuinely keyboard-operable, not just reachable.
struct KeyboardAccessibleChip: View {
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
            .onKeyPress(.space) { isOn.toggle(); return .handled }
            .onKeyPress(.return) { isOn.toggle(); return .handled }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(title)
            .accessibilityValue(isOn ? "On" : "Off")
            .srcLine()
    }
}

struct AccessibleKeyboardPass: View {
    @State private var favoriteOn = false
    @State private var notificationsOn = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Custom controls — hardware-keyboard focusable") {
                    KeyboardAccessibleChip(title: "Add to favorites", isOn: $favoriteOn)
                    KeyboardAccessibleChip(title: "Enable notifications", isOn: $notificationsOn)
                }
            }
            .navigationTitle("Accessible Keyboard (Pass)")
        }
    }
}

#Preview {
    AccessibleKeyboardPass()
}
