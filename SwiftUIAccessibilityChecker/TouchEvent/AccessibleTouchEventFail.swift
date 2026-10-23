import SwiftUI

/// TOUCH EVENT — Fail tier.
///
/// Actions that run the instant a finger lands (a zero-length press, a zero-distance drag),
/// before the person can change their mind. Judged from source (SWIFTUI_TOUCH_DOWN_ACTION).
///
/// Elements covered (2) — every one fails:
///   1. Buy now — onLongPressGesture(minimumDuration: 0)  → BB40136 Fail
///   2. Send    — DragGesture(minimumDistance: 0)         → BB40136 Fail
struct AccessibleTouchEventFail: View {
    @State private var count = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Buy now")
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .onLongPressGesture(minimumDuration: 0) { count += 1 }
                        .srcLine()

                    Text("Send")
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in count += 1 }
                        )
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("TouchEventFail")
        }
    }
}

#Preview {
    AccessibleTouchEventFail()
}
