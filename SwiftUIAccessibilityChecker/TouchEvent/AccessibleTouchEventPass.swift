import SwiftUI

/// TOUCH EVENT — Pass tier.
///
/// Actions that run when the touch is released, so a finger that slides away cancels them.
/// Judged from source (SWIFTUI_TOUCH_UP_ACTION).
///
/// Elements covered (2) — every one passes:
///   1. Add     — Button                → BB40137 Pass
///   2. Counter — Text with onTapGesture → BB40137 Pass
struct AccessibleTouchEventPass: View {
    @State private var count = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button("Add") { count += 1 }
                        .buttonStyle(.borderedProminent)
                        .srcLine()

                    Text("Counter: \(count)")
                        .padding()
                        .background(Color.blue.opacity(0.15))
                        .onTapGesture { count += 1 }
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("TouchEventPass")
        }
    }
}

#Preview {
    AccessibleTouchEventPass()
}
