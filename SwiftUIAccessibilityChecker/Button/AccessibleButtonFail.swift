import SwiftUI

/// BUTTON — Fail tier.
///
/// Buttons that ignore every touch (`.allowsHitTesting(false)`). A button that cannot be pressed
/// is either a mistake or a decoration, so a person is asked to confirm. Judged from source
/// (SWIFTUI_BUTTON_NOT_INTERACTIVE).
///
/// Elements covered (3) — every one is flagged:
///   1. Save   — Button, hit testing off   → BB40001 Validate
///   2. Share  — Button, hit testing off   → BB40001 Validate
///   3. Delete — Button, hit testing off   → BB40001 Validate
struct AccessibleButtonFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button("Save") {}
                        .buttonStyle(.borderedProminent)
                        .allowsHitTesting(false)
                        .srcLine()

                    Button("Share") {}
                        .buttonStyle(.bordered)
                        .allowsHitTesting(false)
                        .srcLine()

                    Button("Delete", role: .destructive) {}
                        .buttonStyle(.bordered)
                        .allowsHitTesting(false)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("ButtonFail")
        }
    }
}

#Preview {
    AccessibleButtonFail()
}
