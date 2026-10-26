import SwiftUI

/// SCREEN TITLE — Fail tier.
///
/// The screen declares no title at all, so there is no BB40099 row. (A missing title is
/// BB40098, which the rule set does not report.)
///
/// Elements covered (1):
///   1. The screen — no `.navigationTitle`   → no BB40099
struct AccessibleScreenTitleFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Order summary")
                        .font(.title2)
                        .srcLine()

                    Text("Two items, arriving Friday")
                        .srcLine()
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    AccessibleScreenTitleFail()
}
