import SwiftUI

/// FORM LABEL — Fail tier.
///
/// Fields whose only name is their placeholder, which vanishes as soon as the person types.
/// Judged from source (SWIFTUI_PLACEHOLDER_ONLY_FIELD).
///
/// Elements covered (3) — every one fails:
///   1. Email    — TextField, placeholder only    → BB40034 Fail
///   2. Password — SecureField, placeholder only  → BB40034 Fail
///   3. Phone    — TextField, placeholder only    → BB40034 Fail
struct AccessibleFormLabelFail: View {
    @State private var email = ""
    @State private var password = ""
    @State private var phone = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .srcLine()

                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .srcLine()

                    TextField("Phone", text: $phone)
                        .textFieldStyle(.roundedBorder)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("FormLabelFail")
        }
    }
}

#Preview {
    AccessibleFormLabelFail()
}
