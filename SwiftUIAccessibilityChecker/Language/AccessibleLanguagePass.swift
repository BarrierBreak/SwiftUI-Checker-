import SwiftUI

/// LANGUAGE — Pass tier.
///
/// Every piece of text is in the app's language (English) and says so. SwiftUI has no
/// modifier for the speech language; a view under `.environment(\.locale, ...)` is the way an
/// element gets one (it surfaces as `accessibilityLanguage`, e.g. "en-Latn-US"). Each reports
/// BB40112 "Language of content matches the language attribute", and the screen reports
/// BB40106 "App language is defined".
///
/// Elements covered (5) — none is a defect:
///   1. Welcome text   2. Summary text   3. Report button   4. Reminder text   5. Footnote
struct AccessibleLanguagePass: View {

    private let english = Locale(identifier: "en")

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Welcome to the wellness dashboard where your daily progress is shown")
                        .environment(\.locale, english)
                        .srcLine()

                    Text("Your weekly summary is ready and shows how many workouts you completed")
                        .environment(\.locale, english)
                        .srcLine()

                    Button("Open the full weekly report for this month") {}
                        .environment(\.locale, english)
                        .srcLine()

                    Text("Remember to drink water and take short walking breaks during the day")
                        .environment(\.locale, Locale(identifier: "en_US"))
                        .srcLine()

                    Text("All figures on this page are updated every night at midnight")
                        .environment(\.locale, english)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Language (Pass)")
        }
    }
}

#Preview {
    AccessibleLanguagePass()
}
