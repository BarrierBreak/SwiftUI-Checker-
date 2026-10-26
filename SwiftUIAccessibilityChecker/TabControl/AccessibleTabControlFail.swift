import SwiftUI

/// TAB CONTROL — Fail tier.
///
/// Both tab controls are `.accessibilityHidden(true)`. VoiceOver cannot reach them, so each is
/// reported as BB40036 "Check if tab control needs to be hidden for screen reader user" — a
/// Validate, because only a person can say whether the tabs are reachable another way.
///
/// Decided from the source — see source_role_linter.py, check_swiftui_batch2_rules.
///
/// Elements covered (2) — both are reported:
///   1. Account tabs — hidden   → BB40036 Validate
///   2. Orders tabs  — hidden   → BB40036 Validate
struct AccessibleTabControlFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Sections").font(.headline).srcLine()

                    TabView {
                        Text("Account overview")
                            .tabItem { Label("Overview", systemImage: "list.bullet") }
                        Text("Account history")
                            .tabItem { Label("History", systemImage: "clock") }
                    }
                    .tabViewStyle(.page)
                    .accessibilityHidden(true)
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
            .navigationTitle("TabControlFail")
        }
    }
}

#Preview {
    AccessibleTabControlFail()
}
