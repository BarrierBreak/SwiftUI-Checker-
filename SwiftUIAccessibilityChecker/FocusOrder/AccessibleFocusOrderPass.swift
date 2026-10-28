import SwiftUI

/// FOCUS ORDER — Pass tier.
///
/// Three buttons whose sort priorities (3, 2, 1) keep the layout order.
///
/// Elements covered (3):
///   1. First, Second and Third step — priorities 3, 2, 1  → BB40054 Pass
struct AccessibleFocusOrderPass: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 48) {
                    VStack(spacing: 24) {
                        Button("First step") {}
                            .accessibilitySortPriority(3)
                            .srcLine()
                        Button("Second step") {}
                            .accessibilitySortPriority(2)
                            .srcLine()
                        Button("Third step") {}
                            .accessibilitySortPriority(1)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("FocusOrderPass")
        }
    }
}

#Preview {
    AccessibleFocusOrderPass()
}
