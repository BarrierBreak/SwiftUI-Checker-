import SwiftUI

/// KEYBOARD CONTROLS — Partial tier for BB40066 "Interactive control cannot receive keyboard focus".
///
/// Read from the code: one control keeps its default focus, one is taken out of the focus
/// order with `.focusable(false)`.
///
/// Elements covered (2):
///   1. "Volume" slider        — default focus          → no row
///   2. "Notifications" toggle — .focusable(false)      → BB40066 Fail
struct AccessibleKeyboardControlPartial: View {
    @State private var volume = 0.5
    @State private var notifications = true

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Slider(value: $volume)
                    .accessibilityLabel("Volume")
                    .srcLine()

                Toggle("Notifications", isOn: $notifications)
                    .focusable(false)
                    .srcLine()
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Keyboard Controls (Partial)")
        }
    }
}

#Preview {
    AccessibleKeyboardControlPartial()
}
