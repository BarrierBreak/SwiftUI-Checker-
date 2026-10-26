import SwiftUI

/// ERROR MESSAGE — Partial tier.
///
/// One error is read by VoiceOver and one is hidden from it.
///
/// Elements covered (2):
///   1. Email error    — exposed                → no row
///   2. Password error — hidden from VoiceOver  → BB40095 Fail
struct AccessibleErrorMessagePartial: View {
    @State private var email = ""
    @State private var password = ""
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
                        Text("Invalid email address — enter a valid address")
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
                        Text("Password required")
                            .font(.footnote)
                            .foregroundColor(.red)
                    .accessibilityHidden(true)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("ErrorMessagePartial")
        }
    }
}

#Preview {
    AccessibleErrorMessagePartial()
}
