import SwiftUI

/// ORIENTATION — Fail tier.
///
/// The screen holds the user to portrait: it will not turn into landscape. It reports BB40056
/// "Screen is locked in orientation".
///
/// Elements covered (1):
///   1. The screen   — portrait only              → BB40056 Fail
struct AccessibleOrientationFail: View {

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Delivery details")
                    .font(.headline)
                    .srcLine()

                Text("Your order will arrive between 9am and 5pm. You can change the address until it ships.")
                    .srcLine()
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Orientation (Fail)")
        }
        .orientationLock(.portrait)
    }
}

#Preview {
    AccessibleOrientationFail()
}
