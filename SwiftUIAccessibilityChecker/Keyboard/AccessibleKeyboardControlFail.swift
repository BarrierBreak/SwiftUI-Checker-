import SwiftUI

/// KEYBOARD CONTROLS — Fail tier.
///
/// Both controls work by touch, but each is taken out of the keyboard focus order with
/// `.focusable(false)`, so Tab and Full Keyboard Access skip them. Each reports BB41036
/// "Interactive control cannot receive keyboard focus".
///
/// Elements covered (2) — every one fails:
///   1. "Quantity" stepper — .focusable(false)
///   2. "Volume" slider    — .focusable(false)
struct AccessibleKeyboardControlFail: View {
    @State private var quantity = 1
    @State private var volume = 0.5

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                    .focusable(false)
                    .srcLine()

                Slider(value: $volume)
                    .accessibilityLabel("Volume")
                    .focusable(false)
                    .srcLine()
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Keyboard Controls (Fail)")
        }
    }
}

#Preview {
    AccessibleKeyboardControlFail()
}
