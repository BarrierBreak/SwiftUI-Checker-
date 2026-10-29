import SwiftUI

/// ORIENTATION — Partial tier.
///
/// The screen holds the user to landscape: it will not turn back to portrait, so it is
/// only half-way to supporting both. It reports BB40056 "Screen is locked in orientation".
///
/// Elements covered (1):
///   1. The screen   — landscape only             → BB40056 Fail
struct AccessibleOrientationPartial: View {

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
            .navigationTitle("Orientation (Partial)")
        }
        .orientationLock(.landscape)
    }
}

#Preview {
    AccessibleOrientationPartial()
}
