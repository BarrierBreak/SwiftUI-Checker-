import SwiftUI

/// NON-TEXT CONTRAST — Pass tier.
///
/// Every border, indicator and control colour is at least 3:1 against the white screen.
/// Nothing is reported.
///
/// Elements covered (3) — none is reported:
///   1. Name field   — #595959 border      (7.0:1)
///   2. Progress     — #0B5CAD tint        (6.7:1)
///   3. Notifications — #0B5CAD switch tint (6.7:1)
struct AccessibleNonTextContrastPass: View {
    @State private var name = ""
    @State private var on = true
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextField("Full name", text: $name)
                        .padding(10)
                        .border(Color(hex: "#595959"), width: 1)
                        .srcLine()

                    ProgressView(value: 0.6)
                        .tint(Color(hex: "#0B5CAD"))
                        .srcLine()

                    Toggle("Notifications", isOn: $on)
                        .tint(Color(hex: "#0B5CAD"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("NonTextContrastPass")
        }
    }
}

#Preview {
    AccessibleNonTextContrastPass()
}
