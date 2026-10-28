import SwiftUI

/// LANGUAGE CHANGE — Partial tier.
///
/// One Text mixes two languages; the other pair is separated correctly.
///
/// Elements covered (3):
///   1. Mixed Text        — English + French in one Text  → BB40107 Fail
///   2. English sentence  — own Text                      → no row
///   3. French sentence   — own Text, locale fr           → no row
struct AccessibleLanguageChangePartial: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Thank you for visiting our shop today, we are open every day of the week. Merci beaucoup pour votre visite aujourd'hui, nous sommes ouverts tous les jours de la semaine.")
                        .srcLine()
                    Text("Thank you for visiting our shop today, we are open every day of the week.")
                        .srcLine()

                    Text("Merci beaucoup pour votre visite aujourd'hui, nous sommes ouverts tous les jours de la semaine.")
                        .environment(\.locale, Locale(identifier: "fr"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("LanguageChangePartial")
        }
    }
}

#Preview {
    AccessibleLanguageChangePartial()
}
