import SwiftUI

/// FOCUS OBSCURED — Pass tier.
///
/// Each button has a "Chat with us" banner, set under it rather than over it, so nothing covers
/// a control. Nothing is reported.
///
/// Elements covered (2) — neither is reported:
///   1. Save — banner below it
///   2. Next — banner below it
struct AccessibleFocusObscuredPass: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 8) {
                        Button("Save") {}
                            .buttonStyle(.borderedProminent)
                            .srcLine()
                        Text("Chat with us — we are online")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.yellow.opacity(0.95))
                            .srcLine()
                    }

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
            .navigationTitle("FocusObscuredPass")
        }
    }
}

#Preview {
    AccessibleFocusObscuredPass()
}
