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
//struct AccessibleErrorMessageFail: View {
//    @State private var email = ""
//    @State private var password = ""
//    @State private var phone = ""
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 24) {
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Email")
//                            .font(.subheadline).srcLine()
//                        TextField("name@example.com", text: $email)
//                            .textFieldStyle(.roundedBorder)
//                            .accessibilityLabel("Email")
//                        Text("Invalid email address")
//                            .font(.footnote)
//                            .foregroundColor(.red)
//                    .accessibilityHidden(true)
//                            .srcLine()
//                    }
//
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Password")
//                            .font(.subheadline)
//                        TextField("At least 8 characters", text: $password)
//                            .textFieldStyle(.roundedBorder)
//                            .accessibilityLabel("Password")
//                        Text("Password required")
//                            .font(.footnote)
//                            .foregroundColor(.red)
//                    .accessibilityHidden(true)
//                            .srcLine()
//                    }
//
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Phone")
//                            .font(.subheadline)
//                        TextField("10 digits", text: $phone)
//                            .textFieldStyle(.roundedBorder)
//                            .accessibilityLabel("Phone")
//                        Text("Phone number is incorrect")
//                            .font(.footnote)
//                            .foregroundColor(.red)
//                    .accessibilityHidden(true)
//                            .srcLine()
//                    }
//                }
//                .padding(24)
//            }
//            .navigationTitle("ErrorMessageFail")
//        }
//    }
//}
//
//#Preview {
//    AccessibleErrorMessageFail()
//}


import SwiftUI
 
/// ERROR MESSAGE — Fail tier.
///
/// Every field shows a red error under it, and every error is `.accessibilityHidden(true)`:
/// a sighted user sees what went wrong and a VoiceOver user is never told. Each is reported
/// as BB40095 "Error message not announced by screen reader".
///
/// The error views are always in the hierarchy (pre-populated), so the scanner sees them on
/// launch. Submit re-validates and updates the text, but nothing is ever announced.
///
/// Elements covered (3) — every one fails:
///   1. Email error    — hidden from VoiceOver   → BB40095
///   2. Password error — hidden from VoiceOver   → BB40095
///   3. Phone error    — hidden from VoiceOver   → BB40095
struct AccessibleErrorMessageFail: View {
    @State private var email = ""
    @State private var password = ""
    @State private var phone = ""
 
    // Pre-populated so the error views exist on launch.
    @State private var emailError: String = "Invalid email address"
    @State private var passwordError: String = "Password required"
    @State private var phoneError: String = "Phone number is incorrect"
 
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.subheadline).srcLine()
                        TextField("name@example.com", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .accessibilityLabel("Email")
                        Text(emailError)
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
                        Text(passwordError)
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
                            .keyboardType(.numberPad)
                            .accessibilityLabel("Phone")
                        Text(phoneError)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .accessibilityHidden(true)
                            .srcLine()
                    }
 
                    Button {
                        submit()
                    } label: {
                        Text("Submit")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(24)
            }
            .navigationTitle("ErrorMessageFail")
        }
    }
 
    private func announce(_ message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
    // MARK: - Validation (returns "" when valid)
 
    private func validateEmail() -> String {
        let value = email.trimmingCharacters(in: .whitespaces)
        if value.isEmpty { return "Email required" }
        let pattern = "^[A-Z0-9a-z._%+\\-]+@[A-Za-z0-9.\\-]+\\.[A-Za-z]{2,}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: value)
        return isValid ? "" : "Invalid email address"
    }
 
    private func validatePassword() -> String {
        if password.isEmpty { return "Password required" }
        return password.count >= 8 ? "" : "Password must be at least 8 characters"
    }
 
    private func validatePhone() -> String {
        let value = phone.trimmingCharacters(in: .whitespaces)
        if value.isEmpty { return "Phone number required" }
        let isTenDigits = value.count == 10 && value.allSatisfy { $0.isASCII && $0.isNumber }
        return isTenDigits ? "" : "Phone number is incorrect"
    }
 
    private func submit() {
        emailError = validateEmail()
        passwordError = validatePassword()
        phoneError = validatePhone()
 
        if !emailError.isEmpty {
            announce(emailError)
        }
 
        guard emailError.isEmpty, passwordError.isEmpty, phoneError.isEmpty else { return }
 
        print("Submitted:", email, password, phone)
    }
}
 
#Preview {
    AccessibleErrorMessageFail()
}
