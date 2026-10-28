import SwiftUI

/// MOTION — Pass tier.
///
/// Two cards act on a shake, and each has an accessible button inside it that does the same
/// thing, so a user who cannot shake the phone loses nothing. Each reports BB40102
/// "Accessible alternative control is available for motion-based action".
///
/// Elements covered (2) — neither is a defect:
///   1. Undo card   — shake to undo, with an "Undo last change" button
///   2. Clear card  — shake to clear, with a "Clear the form" button
struct AccessibleMotionPass: View {

    @State private var undone = 0
    @State private var cleared = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    card("Shake your phone to undo the last change", button: "Undo last change")
                    card("Shake your phone to clear the form", button: "Clear the form")
                }
                .padding(24)
            }
            .navigationTitle("Motion (Pass)")
        }
    }

    private func card(_ prompt: String, button: String) -> some View {
        let isUndo = button == "Undo last change"
        let perform = { if isUndo { undone += 1 } else { cleared += 1 } }
        return VStack(alignment: .leading, spacing: 12) {
            Text(prompt)
            Button(button) { perform() }
                .srcLine()
            if (isUndo ? undone : cleared) > 0 { Text("Done: \(isUndo ? undone : cleared)").font(.footnote) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .onShake { perform() }
    }
}

#Preview {
    AccessibleMotionPass()
}
