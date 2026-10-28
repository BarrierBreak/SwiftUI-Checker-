import SwiftUI

/// FOCUS ORDER — Fail tier.
///
/// Three buttons whose sort priorities (1, 2, 3) reverse the layout order.
///
/// Elements covered (3):
///   1. First, Second and Third step — priorities 1, 2, 3  → BB40053 Validate
struct AccessibleFocusOrderFail: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 48) {
                    VStack(spacing: 24) {
                        Button("First step") {}
                            .accessibilitySortPriority(1)
                            .srcLine()
                        Button("Second step") {}
                            .accessibilitySortPriority(2)
                            .srcLine()
                        Button("Third step") {}
                            .accessibilitySortPriority(3)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("FocusOrderFail")
        }
    }
}

#Preview {
    AccessibleFocusOrderFail()
}
