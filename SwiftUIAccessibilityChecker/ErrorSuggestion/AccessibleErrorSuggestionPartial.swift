import SwiftUI

/// ERROR SUGGESTION — Partial tier.
///
/// One error says how to fix it and one only says what is wrong.
///
/// Elements covered (2):
///   1. Email error    — "… Please enter an address like …"  → BB40097 Pass
///   2. Password error — "Password is required" (no fix)     → no BB40097 row
struct AccessibleErrorSuggestionPartial: View {
    @State private var email = ""
    @State private var password = ""
    @State private var card = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.subheadline)
                        TextField("name@example.com", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityLabel("Email")
                        Text("Invalid email address. Please enter an address like name@example.com")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .srcLine()
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.subheadline)
                        TextField("At least 8 characters", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityLabel("Password")
                        Text("Password is required")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("ErrorSuggestionPartial")
        }
    }
}

#Preview {
    AccessibleErrorSuggestionPartial()
}
