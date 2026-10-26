import SwiftUI

/// NON-TEXT CONTRAST — Fail tier.
///
/// Every border, indicator and control colour is a pale tint that falls well under 3:1 on the
/// white screen. Reported only as failures:
///   BB40062  "Insufficient color contrast for border of form controls"
///   BB40064  "Insufficient color contrast for loading indicator"
///   BB40060  "Insufficient color contrast for non-text element"
///
/// Colours are read from the source (Color(hex:)), against the screen's white.
///
/// Elements covered (4) — every one fails:
///   1. Name field    — #D0D0D0 border       (1.5:1)  → BB40062
///   2. Progress      — #CFE3F7 tint         (1.3:1)  → BB40064
///   3. Notifications — #BFE8C9 switch tint  (1.4:1)  → BB40060
///   4. Star icon     — #E6E6E6              (1.2:1)  → BB40060
struct AccessibleNonTextContrastFail: View {
    @State private var name = ""
    @State private var on = true
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextField("Full name", text: $name)
                        .padding(10)
                        .border(Color(hex: "#D0D0D0"), width: 1)
                        .srcLine()

                    ProgressView(value: 0.6)
                        .tint(Color(hex: "#CFE3F7"))
                        .srcLine()

                    Toggle("Notifications", isOn: $on)
                        .tint(Color(hex: "#BFE8C9"))
                        .srcLine()

                    Image(systemName: "star.fill")
                        .foregroundColor(Color(hex: "#E6E6E6"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("NonTextContrastFail")
        }
    }
}

#Preview {
    AccessibleNonTextContrastFail()
}
