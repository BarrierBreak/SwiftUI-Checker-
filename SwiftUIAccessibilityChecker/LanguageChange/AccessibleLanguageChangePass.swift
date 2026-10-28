import SwiftUI

/// LANGUAGE CHANGE — Pass tier.
///
/// English and French are separate Text views and the French one declares its locale.
///
/// Elements covered (2):
///   1. English sentence  — own Text                    → no row
///   2. French sentence   — own Text, locale fr         → no row
struct AccessibleLanguageChangePass: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Thank you for visiting our shop today, we are open every day of the week.")
                        .srcLine()

                    Text("Merci beaucoup pour votre visite aujourd'hui, nous sommes ouverts tous les jours de la semaine.")
                        .environment(\.locale, Locale(identifier: "fr"))
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("LanguageChangePass")
        }
    }
}

#Preview {
    AccessibleLanguageChangePass()
}
