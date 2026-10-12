import SwiftUI

/// LANGUAGE — Partial tier.
///
/// Some text is declared correctly and some is not.
///
/// Elements covered (5):
///   1. Welcome text    — English, "en"                                → BB40112 Pass
///   2. Summary text    — English, "en_US"                             → BB40112 Pass
///   3. Reminder text   — English, nothing declared                    → BB40110 Fail
///   4. French text     — French, "fr": right, but not the app's       → BB40109 Fail
///   5. Spanish text    — Spanish, "es": right, but not the app's      → BB40109 Fail
struct AccessibleLanguagePartial: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Welcome to the wellness dashboard where your daily progress is shown")
                        .environment(\.locale, Locale(identifier: "en"))
                        .srcLine()

                    Text("Your weekly summary is ready and shows how many workouts you completed")
                        .environment(\.locale, Locale(identifier: "en_US"))
                        .srcLine()

                    Text("Remember to drink water and take short walking breaks during the day")
                        .srcLine()

                    Text("Bienvenue sur le tableau de bord où vos progrès quotidiens sont affichés")
                        .environment(\.locale, Locale(identifier: "fr"))
                        .srcLine()

                    Text("Bienvenido al panel de bienestar donde se muestra tu progreso diario")
                        .environment(\.locale, Locale(identifier: "es"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Language (Partial)")
        }
    }
}

#Preview {
    AccessibleLanguagePartial()
}
