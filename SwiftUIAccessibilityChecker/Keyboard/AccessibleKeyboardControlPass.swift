import SwiftUI

/// KEYBOARD CONTROLS — Pass tier for BB40066 "Interactive control cannot receive keyboard focus".
///
/// Read from the code: no control is taken out of the focus order with `.focusable(false)`.
/// A disabled control that also says `.focusable(false)` is not a defect — being skipped by Tab
/// is what disabled means — so it is not reported either.
///
/// Elements covered (5) — none fails:
///   1. "Quantity" stepper      — default focus                         → no row
///   2. "Volume" slider         — default focus                         → no row
///   3. "Notifications" toggle  — default focus                         → no row
///   4. "Promo code" field      — default focus                         → no row
///   5. "Express delivery"      — .disabled(true) + .focusable(false)   → no row (disabled)
struct AccessibleKeyboardControlPass: View {
    @State private var quantity = 1
    @State private var volume = 0.5
    @State private var notifications = true
    @State private var promo = ""
    @State private var express = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                    .srcLine()

                Slider(value: $volume)
                    .accessibilityLabel("Volume")
                    .srcLine()

                Toggle("Notifications", isOn: $notifications)
                    .srcLine()

                TextField("Promo code", text: $promo)
                    .textFieldStyle(.roundedBorder)
                    .srcLine()

                Toggle("Express delivery", isOn: $express)
                    .disabled(true)
                    .focusable(false)
                    .srcLine()
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Keyboard Controls (Pass)")
        }
    }
}

#Preview {
    AccessibleKeyboardControlPass()
}
