import SwiftUI

/// HIDDEN FROM SCREEN READER — Fail tier.
///
/// Every control here is on screen and works by touch, and none of them can be reached with
/// VoiceOver, because `.accessibilityHidden(true)` removes a view from the accessibility
/// tree entirely. Each is reported as BB40046 "Interactive controls hidden from screen
/// reader user".
///
/// SwiftUI never hands a hidden view to the hosting view, so this is decided from the
/// source rather than the running screen — see source_role_linter.py,
/// check_swiftui_hidden_from_screen_reader.
///
/// Elements covered (7) — every one fails:
///   1. Pay now          — Button, hidden on itself
///   2. Notifications    — Toggle, hidden on itself
///   3. Volume           — Slider, hidden on itself
///   4. Quantity         — Stepper, hidden on itself
///   5. Search field     — TextField, hidden on itself
///   6. Terms            — Link, hidden on itself
///   7. Delete account   — Button inside a VStack that is hidden: the container takes
///                         everything beneath it out of the tree
struct AccessibleHiddenFail: View {

    @State private var notifications = true
    @State private var volume = 0.5
    @State private var quantity = 1
    @State private var query = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text("Account")
                        .font(.headline)
                        .srcLine()

                    Button("Pay now") {}
                        .buttonStyle(.borderedProminent)
                        .accessibilityHidden(true)
                        .srcLine()

                    Toggle("Notifications", isOn: $notifications)
                        .accessibilityHidden(true)
                        .srcLine()

                    Slider(value: $volume)
                        .accessibilityLabel("Volume")
                        .accessibilityHidden(true)
                        .srcLine()

                    Stepper("Quantity: \(quantity)", value: $quantity)
                        .accessibilityHidden(true)
                        .srcLine()

                    TextField("Search", text: $query)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityHidden(true)
                        .srcLine()

                    Link("Terms of service", destination: URL(string: "https://example.com/terms")!)
                        .accessibilityHidden(true)
                        .srcLine()

                    VStack(alignment: .leading) {
                        Button("Delete account") {}
                            .srcLine()
                    }
                    .accessibilityHidden(true)
                }
                .padding(24)
            }
            .navigationTitle("Hidden (Fail)")
        }
    }
}

#Preview {
    AccessibleHiddenFail()
}
