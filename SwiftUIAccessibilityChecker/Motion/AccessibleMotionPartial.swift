import SwiftUI

/// MOTION — Partial tier.
///
/// Two cards act on a shake. One has an accessible alternative and one does not.
///
/// Elements covered (2):
///   1. Undo card   — shake to undo, with an "Undo last change" button   → BB40102 Pass
///   2. Clear card  — shake to clear, nothing else on the card           → BB40052 Fail
struct AccessibleMotionPartial: View {

    @State private var undone = 0
    @State private var cleared = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shake your phone to undo the last change")
                        Button("Undo last change") { undone += 1 }
                            .srcLine()
                        if undone > 0 { Text("Done: \(undone)").font(.footnote) }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .onShake { undone += 1 }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shake your phone to clear the form")
                        if cleared > 0 { Text("Done: \(cleared)").font(.footnote) }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .onShake { cleared += 1 }
                }
                .padding(24)
            }
            .navigationTitle("Motion (Partial)")
        }
    }
}

#Preview {
    AccessibleMotionPartial()
}
