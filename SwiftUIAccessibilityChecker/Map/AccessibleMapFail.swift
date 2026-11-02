import SwiftUI
import MapKit

/// MAP TEXT ALTERNATIVE — Fail tier.
///
/// Neither map tells a VoiceOver user what it shows.
///
/// Elements covered (2) — every one is a defect:
///   1. Store map    — no .accessibilityLabel        → BB40140 Fail
///   2. Delivery map — .accessibilityLabel("") empty → BB40140 Fail
struct AccessibleMapFail: View {
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
                        .srcLine()
                    Map(initialPosition: .region(Self.pune))
                        .frame(height: 200)
                        .accessibilityLabel("")
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("MapFail")
        }
    }
}

#Preview {
    AccessibleMapFail()
}
