import SwiftUI

/// FORM LABEL — Pass tier.
///
/// Every field has a visible label above it. Nothing is reported under BB40034 (no
/// "nothing found" row).
///
/// Elements covered (2) — none reports BB40034:
///   1. Email    — TextField, Text label above    → no BB40034 row
///   2. Password — SecureField, Text label above  → no BB40034 row
struct AccessibleFormLabelPass: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                        TextField("name@example.com", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .srcLine()
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                        SecureField("At least 8 characters", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("FormLabelPass")
        }
    }
}

#Preview {
    AccessibleFormLabelPass()
}
