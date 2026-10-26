import SwiftUI

/// TAB CONTROL — Pass tier.
///
/// Both tab controls are left in the accessibility tree. Nothing is reported.
///
/// Elements covered (2) — neither is reported:
///   1. Account tabs
///   2. Orders tabs
struct AccessibleTabControlPass: View {

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
                    .frame(height: 120)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("TabControlPass")
        }
    }
}

#Preview {
    AccessibleTabControlPass()
}
