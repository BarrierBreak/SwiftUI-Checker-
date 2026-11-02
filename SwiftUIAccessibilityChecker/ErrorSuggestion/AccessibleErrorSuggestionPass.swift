import SwiftUI

/// ERROR SUGGESTION — Pass tier.
///
/// Every error is read by VoiceOver and says how to fix it.
///
/// Elements covered (2) — none is a defect:
///   1. Email error    — "… Please enter an address like …"  → BB40097 Pass
///   2. Password error — "… Try adding a number."            → BB40097 Pass
struct AccessibleErrorSuggestionPass: View {
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
                        Text("Password must have 8 characters. Try adding a number.")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("ErrorSuggestionPass")
        }
    }
}

#Preview {
    AccessibleErrorSuggestionPass()
}
