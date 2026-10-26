import SwiftUI

/// FOCUS OBSCURED — Partial tier.
///
/// One button is covered by its banner and one is not.
///
/// Elements covered (2):
///   1. Save — fully covered by the banner   → BB40075 Validate
///   2. Next — banner below it               → no row
struct AccessibleFocusObscuredPartial: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ZStack {
                        Button("Save") {}
                            .buttonStyle(.borderedProminent)
                            .srcLine()
                        Text("Chat with us — we are online")
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Color.yellow.opacity(0.95))
                            .srcLine()
                    }
                    .frame(height: 90)

                    VStack(spacing: 8) {
                        Button("Next") {}
                            .buttonStyle(.borderedProminent)
                            .srcLine()
                        Text("Chat with us — we are online")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.yellow.opacity(0.95))
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("FocusObscuredPartial")
        }
    }
}

#Preview {
    AccessibleFocusObscuredPartial()
}
