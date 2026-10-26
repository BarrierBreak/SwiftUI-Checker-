import SwiftUI

/// SCREEN TITLE — Pass tier.
///
/// The screen declares a title with `.navigationTitle("Order summary")`, which VoiceOver reads
/// as the screen's name. Reported once, as BB40099 "Title is specified for screen".
///
/// Elements covered (1):
///   1. The screen — `.navigationTitle("Order summary")`   → BB40099 Pass
struct AccessibleScreenTitlePass: View {

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
            .navigationTitle("Order summary")
        }
    }
}

#Preview {
    AccessibleScreenTitlePass()
}
