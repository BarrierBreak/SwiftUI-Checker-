import SwiftUI

/// HIDDEN FROM SCREEN READER — Pass tier.
///
/// Everything a sighted user can read or operate is also in the accessibility tree, and the
/// only thing kept out of it is decoration that carries nothing: an image with no
/// description. Nothing here is reported — a scan that finds nothing hidden says nothing.
///
/// Elements covered (8) — none is a defect:
///   1. Title            — Text, exposed
///   2. Pay button       — Button, exposed
///   3. Notifications    — Toggle, exposed
///   4. Volume           — Slider, exposed
///   5. Quantity         — Stepper, exposed
///   6. Name field       — TextField, exposed
///   7. Combined card    — two Texts merged into one element: neither is "hidden"
///   8. Decorative image — no description, hidden on purpose: correctly absent
struct AccessibleHiddenPass: View {

    @State private var notifications = true
    @State private var volume = 0.5
    @State private var quantity = 1
    @State private var name = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text("Account overview")
                        .font(.headline)
                        .srcLine()

                    Button("Pay now") {}
                        .buttonStyle(.borderedProminent)
                        .srcLine()

                    Toggle("Notifications", isOn: $notifications)
                        .srcLine()

                    Slider(value: $volume)
                        .accessibilityLabel("Volume")
                        .srcLine()

                    Stepper("Quantity: \(quantity)", value: $quantity)
                        .srcLine()

                    TextField("Full name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel("Full name")
                        .srcLine()

                    // One element for the whole card; the Texts inside are read through it.
                    VStack(alignment: .leading) {
                        Text("Balance")
                        Text("$42.00 due Friday")
                    }
                    .accessibilityElement(children: .combine)
                    .srcLine()

                    // Decoration with no description — hiding it is the right call.
                    Image(systemName: "sparkles")
                        .accessibilityHidden(true)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Hidden (Pass)")
        }
    }
}

#Preview {
    AccessibleHiddenPass()
}
