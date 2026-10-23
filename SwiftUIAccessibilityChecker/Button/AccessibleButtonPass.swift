import SwiftUI

/// BUTTON — Pass tier.
///
/// Ordinary buttons that take touches. Nothing here is reported under BB40001 (there is no
/// "nothing found" row); each button's release-to-activate behaviour passes BB40137.
///
/// Elements covered (3) — none reports BB40001:
///   1. Save   — Button    → no BB40001 row
///   2. Share  — Button    → no BB40001 row
///   3. Delete — Button    → no BB40001 row
struct AccessibleButtonPass: View {

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
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("ButtonPass")
        }
    }
}

#Preview {
    AccessibleButtonPass()
}
