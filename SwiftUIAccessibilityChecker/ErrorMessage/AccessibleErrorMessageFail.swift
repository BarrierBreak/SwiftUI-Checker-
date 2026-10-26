import SwiftUI

/// ERROR MESSAGE — Fail tier.
///
/// Every field shows a red error under it, and every error is `.accessibilityHidden(true)`:
/// a sighted user sees what went wrong and a VoiceOver user is never told. Each is reported
/// as BB40095 "Error message not announced by screen reader".
///
/// SwiftUI never hands a hidden view to the accessibility tree, so this is decided from the
/// source — see source_role_linter.py, check_swiftui_batch2_rules.
///
/// Elements covered (3) — every one fails:
///   1. Email error    — hidden from VoiceOver   → BB40095
///   2. Password error — hidden from VoiceOver   → BB40095
///   3. Phone error    — hidden from VoiceOver   → BB40095
struct AccessibleErrorMessageFail: View {
    @State private var email = ""
    @State private var password = ""
    @State private var phone = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.subheadline).srcLine()
                        TextField("name@example.com", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityLabel("Email")
                        Text("Invalid email address")
                            .font(.footnote)
                            .foregroundColor(.red)
                    .accessibilityHidden(true)
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

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Phone")
                            .font(.subheadline)
                        TextField("10 digits", text: $phone)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityLabel("Phone")
                        Text("Phone number is incorrect")
                            .font(.footnote)
                            .foregroundColor(.red)
                    .accessibilityHidden(true)
                            .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("ErrorMessageFail")
        }
    }
}

#Preview {
    AccessibleErrorMessageFail()
}
