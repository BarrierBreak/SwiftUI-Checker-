//
//  AccessibleFocusOrderRedirectFail.swift
//  Accessibility test cases: Focus order
//
//  WCAG 2.4.3 Focus Order (Level A)
//
//  One view, three functional FAIL scenarios, chosen with the segmented control.
//  Each case moves focus in code, so the wrong order happens no matter how
//  iOS would normally sort the elements on screen.
//
//    FO-01  Keyboard (Tab / Return): Name -> PIN code -> Address -> City
//    FO-02  VoiceOver swipe order:   Heading -> Password -> Email -> Sign In
//    FO-03  Custom dialog: focus sent behind the dialog on open, and to the
//           bottom of the page on close
//
//  Elements covered (2) — each is a focus state whose .onChange reassigns it:
//    1. keyboardField     (FO-01 form fields)    -> BB40053 Validate
//    2. voiceOverFocus    (FO-02 sign-in form)   -> BB40053 Validate
//  FO-03 moves focus from Tasks, not from an .onChange, so the source check does not see it.

import SwiftUI

struct AccessibleFocusOrderRedirectFail: View {

    // Selected test case (1...3)
    @State private var selectedCase = 1

    // MARK: FO-01 state  (1 = Full name, 2 = Address, 3 = City, 4 = PIN code)
    @FocusState private var keyboardField: Int?
    @State private var lastKeyboardField: Int?
    @State private var isRedirectingKeyboard = false
    @State private var shipName = ""
    @State private var shipAddress = ""
    @State private var shipCity = ""
    @State private var shipPincode = ""
    @State private var addressSaved = false

    /// Defect: the "next" field for each field, in an illogical order.
    /// Visual order is 1 -> 2 -> 3 -> 4.
    private let keyboardNext: [Int: Int] = [1: 4, 4: 2, 2: 3, 3: 1]

    // MARK: FO-02 state  (1 = heading, 2 = Email, 3 = Password, 4 = Sign In)
    @AccessibilityFocusState private var voiceOverFocus: Int?
    @State private var lastVoiceOverFocus: Int?
    @State private var isRedirectingVoiceOver = false
    @State private var email = ""
    @State private var password = ""
    @State private var signInMessage = ""

    /// Defect: the element VoiceOver is sent to after each element.
    /// Visual order is 1 -> 2 -> 3 -> 4.
    private let voiceOverNext: [Int: Int] = [1: 3, 3: 2, 2: 4, 4: 1]

    // MARK: FO-03 state
    // (1 = page heading, 2 = Delete account, 3 = Contact support, 4 = Sign out)
    @AccessibilityFocusState private var dialogPageFocus: Int?
    @State private var showDialog = false
    @State private var accountStatus = "Account active"

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    Picker("Test case", selection: $selectedCase) {
                        Text("FO-01").tag(1)
                        Text("FO-02").tag(2)
                        Text("FO-03").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    Group {
                        switch selectedCase {
                        case 1:  keyboardOrderCase
                        case 2:  voiceOverOrderCase
                        default: dialogFocusCase
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }

                if showDialog {
                    customDialog
                }
            }
            .navigationTitle("Focus Order")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - FO-01  Keyboard focus order (Tab and Return)

    private var keyboardOrderCase: some View {
        Form {
            Section("Shipping address") {
                TextField("Full name", text: $shipName)
                    .focused($keyboardField, equals: 1)
                    .submitLabel(.next)
                    .onSubmit { keyboardField = keyboardNext[1] }
                    .srcLine()

                TextField("Address", text: $shipAddress)
                    .focused($keyboardField, equals: 2)
                    .submitLabel(.next)
                    .onSubmit { keyboardField = keyboardNext[2] }

                TextField("City", text: $shipCity)
                    .focused($keyboardField, equals: 3)
                    .submitLabel(.next)
                    .onSubmit { keyboardField = keyboardNext[3] }

                TextField("PIN code", text: $shipPincode)
                    .focused($keyboardField, equals: 4)
                    .submitLabel(.next)
                    .onSubmit { keyboardField = keyboardNext[4] }
            }

            Section {
                Button("Save address") {
                    lastKeyboardField = nil
                    keyboardField = nil
                    addressSaved = true
                }
                if addressSaved {
                    Text("Address saved.")
                        .foregroundStyle(.secondary)
                }
            }
        }
        // Defect: whenever keyboard focus moves from one field to another
        // (Tab, Shift-Tab, Return, Full Keyboard Access), it is redirected
        // to the scrambled "next" field instead.
        .onChange(of: keyboardField) { _, newValue in
            if isRedirectingKeyboard {
                isRedirectingKeyboard = false
                lastKeyboardField = newValue
                return
            }
            guard let newValue else {
                lastKeyboardField = nil
                return
            }
            if let last = lastKeyboardField,
               let target = keyboardNext[last],
               newValue != last,
               newValue != target {
                isRedirectingKeyboard = true
                keyboardField = target
            } else {
                lastKeyboardField = newValue
            }
        }
    }

    // MARK: - FO-02  VoiceOver swipe order

    private var voiceOverOrderCase: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Sign in")
                    .font(.title2.bold())
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityFocused($voiceOverFocus, equals: 1)
                    .srcLine()

                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                    .accessibilityFocused($voiceOverFocus, equals: 2)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityFocused($voiceOverFocus, equals: 3)

                Button("Sign In") {
                    signInMessage = email.isEmpty || password.isEmpty
                        ? "Enter email and password."
                        : "Signed in as \(email)."
                }
                .buttonStyle(.borderedProminent)
                .accessibilityFocused($voiceOverFocus, equals: 4)

                if !signInMessage.isEmpty {
                    Text(signInMessage)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        // Defect: when VoiceOver moves from one form element to another,
        // focus is redirected to the scrambled "next" element.
        .onChange(of: voiceOverFocus) { _, newValue in
            if isRedirectingVoiceOver {
                isRedirectingVoiceOver = false
                lastVoiceOverFocus = newValue
                return
            }
            guard let newValue else { return }
            if let last = lastVoiceOverFocus,
               let target = voiceOverNext[last],
               newValue != last,
               newValue != target {
                isRedirectingVoiceOver = true
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(200))
                    voiceOverFocus = target
                }
            } else {
                lastVoiceOverFocus = newValue
            }
        }
    }

    // MARK: - FO-03  Custom dialog focus

    private var dialogFocusCase: some View {
        VStack(spacing: 20) {
            Text("Account settings")
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($dialogPageFocus, equals: 1)

            Text(accountStatus)
                .font(.headline)

            Button("Delete account", role: .destructive) {
                showDialog = true
                // Defect: focus is sent to a control behind the dialog.
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(400))
                    dialogPageFocus = 3
                }
            }
            .buttonStyle(.bordered)
            .accessibilityFocused($dialogPageFocus, equals: 2)

            Button("Contact support") {
                accountStatus = "Support request sent"
            }
            .buttonStyle(.bordered)
            .accessibilityFocused($dialogPageFocus, equals: 3)

            Spacer()

            Button("Sign out") {
                accountStatus = "Signed out"
            }
            .accessibilityFocused($dialogPageFocus, equals: 4)
        }
        .padding()
    }

    private var customDialog: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { closeDialog() }

            VStack(spacing: 16) {
                Text("Delete account?")
                    .font(.headline)
                Text("This action cannot be undone.")
                    .font(.subheadline)
                HStack(spacing: 24) {
                    Button("Cancel") {
                        closeDialog()
                    }
                    Button("Delete", role: .destructive) {
                        accountStatus = "Account deleted"
                        closeDialog()
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            )
            .padding(32)
            // Defect: no .isModal trait, so the page behind stays reachable
            // with VoiceOver and the keyboard.
        }
    }

    private func closeDialog() {
        showDialog = false
        // Defect: focus goes to "Sign out" at the bottom of the page instead
        // of back to "Delete account", which opened the dialog.
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(400))
            dialogPageFocus = 4
        }
    }
}

#Preview {
    AccessibleFocusOrderRedirectFail()
}
