import SwiftUI

/// SCREEN TITLE — Partial tier.
///
/// The title is declared the less common way, with a Text value, and the screen shows its
/// content under a heading of its own. It still has a title, so it reports BB40099 once.
///
/// Elements covered (1):
///   1. The screen — `.navigationTitle(Text("Order summary"))`   → BB40099 Pass
struct AccessibleScreenTitlePartial: View {

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
            .navigationTitle(Text("Order summary"))
        }
    }
}

#Preview {
    AccessibleScreenTitlePartial()
}
