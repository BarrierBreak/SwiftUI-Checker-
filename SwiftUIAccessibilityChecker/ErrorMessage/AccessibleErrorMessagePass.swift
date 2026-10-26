import SwiftUI

/// ERROR MESSAGE — Pass tier.
///
/// Each field shows its error under it, and the error is an ordinary Text, so VoiceOver reads
/// it. Nothing is reported for BB40095.
///
/// Elements covered (2) — neither is reported:
///   1. Email    — error Text, exposed
///   2. Password — error Text, exposed
struct AccessibleErrorMessagePass: View {
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
                        Text("Password required — enter at least 8 characters")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("ErrorMessagePass")
        }
    }
}

#Preview {
    AccessibleErrorMessagePass()
}
