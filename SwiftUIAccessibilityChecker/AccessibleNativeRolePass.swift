import SwiftUI

/// Demonstrates the most common source of role bugs in practice: a
/// developer recreates a native control's LOOK from scratch (for custom
/// styling) and, in doing so, silently drops the ROLE and VALUE that the
/// native control gave them for free. Every scenario here pairs a native
/// SwiftUI control (which gets the correct accessibility role
/// automatically, no extra code) against a hand-built visual clone in
/// AccessibleNativeRolePartial/Fail.
struct AccessibleNativeRolePass: View {

    @State private var notificationsOn = false
    @State private var volume: Double = 0.5
    @State private var quantity = 1
    @State private var selectedColorOption = "Blue"
    @State private var agreedToTerms = false

    private let colorOptions = ["Red", "Green", "Blue"]

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Toggle — native
                Section("Toggle") {
                    Toggle(isOn: $notificationsOn) {
                        Text("Enable Notifications")
                    }
                        .srcLine()
                    // No accessibility modifiers needed: SwiftUI's Toggle
                    // ships with the correct role and an accessibilityValue
                    // of "On"/"Off" automatically synced to $notificationsOn.
                }

                // MARK: Slider — native
                Section("Slider") {
                    Slider(value: $volume, in: 0...1) {
                        Text("Volume")
                    }
                        .srcLine()
                    // Automatically adjustable — VoiceOver swipe up/down
                    // changes the value, and accessibilityValue updates
                    // itself as the user drags, with zero extra code.
                }

                // MARK: Stepper — native
                Section("Stepper") {
                    Stepper(value: $quantity, in: 1...10) {
                        Text("Quantity: \(quantity)")
                    }
                        .srcLine()
                    // Automatically exposes increment/decrement actions
                    // and announces the current quantity after each change.
                }

                // MARK: Segmented Picker — native
                Section("Segmented Picker") {
                    Picker("Favorite color", selection: $selectedColorOption) {
                        ForEach(colorOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                        .srcLine()
                    // Each segment automatically gets button + selected
                    // traits from SwiftUI — no manual trait wiring needed.
                }

                // MARK: Checkbox-style Toggle — native
                Section("Checkbox-style Toggle") {
                    Toggle(isOn: $agreedToTerms) {
                        Text("I agree to the Terms of Service")
                    }
                    .toggleStyle(.switch)
                        .srcLine()
                    // iOS has no native "checkbox" control — Toggle in
                    // .switch style is the semantically correct native
                    // equivalent, and still gets a free, correct role/value.
                }
            }
            .navigationTitle("Native Controls")
        }
    }
}

#Preview {
    AccessibleNativeRolePass()
}
