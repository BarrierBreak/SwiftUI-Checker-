import SwiftUI

/// TAB CONTROL — Partial tier.
///
/// One tab control is reachable and one is hidden.
///
/// Elements covered (2):
///   1. Account tabs — in the tree  → no row
///   2. Orders tabs  — hidden       → BB40036 Validate
struct AccessibleTabControlPartial: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TabView {
                        Text("Account overview")
                            .tabItem { Label("Overview", systemImage: "list.bullet") }
                        Text("Account history")
                            .tabItem { Label("History", systemImage: "clock") }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 120)
                    .srcLine()

                    TabView {
                        Text("Orders overview")
                            .tabItem { Label("Overview", systemImage: "list.bullet") }
                        Text("Orders history")
                            .tabItem { Label("History", systemImage: "clock") }
                    }
                    .tabViewStyle(.page)
                    .accessibilityHidden(true)
                    .frame(height: 120)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("TabControlPartial")
        }
    }
}

#Preview {
    AccessibleTabControlPartial()
}
