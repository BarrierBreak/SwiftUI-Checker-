import SwiftUI
import MapKit

/// MAP TEXT ALTERNATIVE — Partial tier.
///
/// One map is described and one is not.
///
/// Elements covered (2):
///   1. Store map    — .accessibilityLabel("Map of store locations in Mumbai")  → BB40141 Pass
///   2. Delivery map — no .accessibilityLabel                                   → BB40140 Fail
struct AccessibleMapPartial: View {
    private static let mumbai = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    private static let pune = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 18.5204, longitude: 73.8567),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Our stores")
                        .font(.headline)
                        .srcLine()
                    Map(initialPosition: .region(Self.mumbai))
                        .frame(height: 200)
                        .accessibilityLabel("Map of store locations in Mumbai")
                        .srcLine()
                    Map(initialPosition: .region(Self.pune))
                        .frame(height: 200)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("MapPartial")
        }
    }
}

#Preview {
    AccessibleMapPartial()
}
