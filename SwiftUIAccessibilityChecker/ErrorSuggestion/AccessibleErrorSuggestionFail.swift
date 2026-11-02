import SwiftUI

/// ERROR SUGGESTION — Fail tier.
///
/// No error both reaches VoiceOver and says how to fix it. BB40097 is a Pass-only rule, so
/// this screen produces no BB40097 row at all.
///
/// Elements covered (3) — every one is a defect:
///   1. Password error — "Password is required" (no fix)                      → no BB40097 row
///   2. Card error     — "Card number is incorrect" (no fix)                  → no BB40097 row
///   3. Email error    — suggests a fix but is .accessibilityHidden(true)     → BB40095 Fail, no BB40097 row
struct AccessibleErrorSuggestionFail: View {
    @State private var email = ""
    @State private var password = ""
    @State private var card = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
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
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Card number")
                            .font(.subheadline)
                        TextField("16 digits", text: $card)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityLabel("Card number")
                        Text("Card number is incorrect")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .srcLine()
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.subheadline)
                        TextField("name@example.com", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityLabel("Email")
                        Text("Invalid email address. Please check for a typo.")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .accessibilityHidden(true)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("ErrorSuggestionFail")
        }
    }
}

#Preview {
    AccessibleErrorSuggestionFail()
}
