import SwiftUI

/// LANGUAGE — Fail tier.
///
/// Every piece of text has a language problem, one of each kind the rules tell apart:
///
///   no attribute        — BB40110 "Missing language attribute for content"
///   not the app's       — BB40109 "Language of content does not match app language"
///   wrong for the text  — BB40111 "Language attribute does not match the content"
///
/// Elements covered (5) — every one fails:
///   1. Greeting text   — English, nothing declared                    → BB40110
///   2. Report button   — English, nothing declared                    → BB40110
///   3. French text     — French, declared "fr": right for the text,
///                        but not the app's language                   → BB40109
///   4. Tip text        — French text declared "en"                    → BB40111
///   5. Notice text     — English text declared "de"                   → BB40111
struct AccessibleLanguageFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Welcome to the wellness dashboard where your daily progress is shown")
                        .srcLine()

                    Button("Open the full weekly report for this month") {}
                        .srcLine()

                    Text("Bienvenue sur le tableau de bord où vos progrès quotidiens sont affichés")
                        .environment(\.locale, Locale(identifier: "fr"))
                        .srcLine()

                    Text("N'oubliez pas de boire de l'eau et de faire de courtes pauses pendant la journée")
                        .environment(\.locale, Locale(identifier: "en"))
                        .srcLine()

                    Text("All figures on this page are updated every night at midnight")
                        .environment(\.locale, Locale(identifier: "de"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Language (Fail)")
        }
    }
}

#Preview {
    AccessibleLanguageFail()
}
