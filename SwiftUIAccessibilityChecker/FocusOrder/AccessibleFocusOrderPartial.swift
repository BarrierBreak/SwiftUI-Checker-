import SwiftUI

/// FOCUS ORDER — Partial tier.
///
/// One group keeps the layout order and one reverses it.
///
/// Elements covered (6):
///   1. First, Second and Third step — priorities 3, 2, 1  → BB40054 Pass
///   2. Review, Confirm and Submit   — priorities 1, 2, 3  → BB40053 Validate
struct AccessibleFocusOrderPartial: View {
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
                    VStack(spacing: 24) {
                        Button("Review") {}
                            .accessibilitySortPriority(1)
                            .srcLine()
                        Button("Confirm") {}
                            .accessibilitySortPriority(2)
                            .srcLine()
                        Button("Submit") {}
                            .accessibilitySortPriority(3)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("FocusOrderPartial")
        }
    }
}

#Preview {
    AccessibleFocusOrderPartial()
}
