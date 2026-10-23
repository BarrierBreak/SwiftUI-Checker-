import SwiftUI

/// STATE TRAIT — Fail tier.
///
/// Controls that look unavailable or selected but never tell VoiceOver: the dimmed button is
/// still enabled, and the chip's selection is shown by colour alone. A wrong state is not
/// reported under BB40277 (that rule only passes); the older state rules (BB60052) describe
/// these. Expected BB40277 rows: none.
///
/// Elements covered (2) — neither passes:
///   1. Submit — dimmed with opacity, never .disabled    → no BB40277 row
///   2. Unread — selection shown by colour only          → no BB40277 row
struct AccessibleStateTraitFail: View {
    @State private var ready = false
    @State private var chosen = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button("Submit") {}
                        .buttonStyle(.borderedProminent)
                        .opacity(ready ? 1 : 0.4)
                        .srcLine()

                    Text("Unread")
                        .padding(8)
                        .background(chosen ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundStyle(chosen ? Color.white : Color.primary)
                        .onTapGesture { chosen.toggle() }
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("StateTraitFail")
        }
    }
}

#Preview {
    AccessibleStateTraitFail()
}
