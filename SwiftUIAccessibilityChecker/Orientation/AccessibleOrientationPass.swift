import SwiftUI

/// ORIENTATION — Pass tier.
///
/// The screen turns with the device, in portrait and in landscape. It reports BB40055 as a
/// Validate: a person confirms that all of the content is still there in each orientation.
///
/// Elements covered (1):
///   1. The screen   — allows every orientation   → BB40055 Validate
struct AccessibleOrientationPass: View {

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
            .navigationTitle("Orientation (Pass)")
        }
    }
}

#Preview {
    AccessibleOrientationPass()
}
