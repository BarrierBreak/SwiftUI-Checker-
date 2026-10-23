import SwiftUI

/// TOUCH EVENT — Partial tier.
///
/// One action runs on release; one runs on touch-down.
///
/// Elements covered (2):
///   1. Add     — Button                                  → BB40137 Pass
///   2. Buy now — onLongPressGesture(minimumDuration: 0)  → BB40136 Fail
struct AccessibleTouchEventPartial: View {
    @State private var count = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button("Add") { count += 1 }
                        .buttonStyle(.borderedProminent)
                        .srcLine()

                    Text("Buy now")
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .onLongPressGesture(minimumDuration: 0) { count += 1 }
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("TouchEventPartial")
        }
    }
}

#Preview {
    AccessibleTouchEventPartial()
}
