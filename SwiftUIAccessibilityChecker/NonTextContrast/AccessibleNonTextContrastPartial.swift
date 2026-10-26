import SwiftUI

/// NON-TEXT CONTRAST — Partial tier.
///
/// Two of the four are dark enough; the other two are pale tints.
///
/// Elements covered (4):
///   1. Name field    — #595959 border       (7.0:1)  → no row
///   2. Email field   — #D0D0D0 border       (1.5:1)  → BB40062 Fail
///   3. Progress      — #CFE3F7 tint         (1.3:1)  → BB40064 Fail
///   4. Notifications — #0B5CAD switch tint  (6.7:1)  → no row
struct AccessibleNonTextContrastPartial: View {
    @State private var name = ""
    @State private var email = ""
    @State private var on = true
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextField("Full name", text: $name)
                        .padding(10)
                        .border(Color(hex: "#595959"), width: 1)
                        .srcLine()

                    TextField("Email", text: $email)
                        .padding(10)
                        .border(Color(hex: "#D0D0D0"), width: 1)
                        .srcLine()

                    ProgressView(value: 0.6)
                        .tint(Color(hex: "#CFE3F7"))
                        .srcLine()

                    Toggle("Notifications", isOn: $on)
                        .tint(Color(hex: "#0B5CAD"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("NonTextContrastPartial")
        }
    }
}

#Preview {
    AccessibleNonTextContrastPartial()
}
