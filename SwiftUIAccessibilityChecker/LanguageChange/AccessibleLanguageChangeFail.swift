import SwiftUI

/// LANGUAGE CHANGE — Fail tier.
///
/// Each Text mixes an English and a French sentence, and SwiftUI cannot tag part of a Text.
///
/// Elements covered (2):
///   1. Greeting — one Text, English + French  → BB40107 Fail
///   2. Hours    — one Text, English + French  → BB40107 Fail
struct AccessibleLanguageChangeFail: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Thank you for visiting our shop today, we are open every day of the week. Merci beaucoup pour votre visite aujourd'hui, nous sommes ouverts tous les jours de la semaine.")
                        .srcLine()
                    Text("Our friendly staff will gladly help you find everything you need today. Notre personnel sera heureux de vous aider à trouver tout ce dont vous avez besoin aujourd'hui.")
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("LanguageChangeFail")
        }
    }
}

#Preview {
    AccessibleLanguageChangeFail()
}
