import SwiftUI

/// BUTTON — Partial tier.
///
/// Two buttons work; one ignores touches.
///
/// Elements covered (3):
///   1. Save   — Button                    → no BB40001 row
///   2. Share  — Button                    → no BB40001 row
///   3. Delete — Button, hit testing off   → BB40001 Validate
struct AccessibleButtonPartial: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button("Save") {}
                        .buttonStyle(.borderedProminent)
                        .srcLine()

                    Button("Share") {}
                        .buttonStyle(.bordered)
                        .srcLine()

                    Button("Delete", role: .destructive) {}
                        .buttonStyle(.bordered)
                        .allowsHitTesting(false)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("ButtonPartial")
        }
    }
}

#Preview {
    AccessibleButtonPartial()
}
