import SwiftUI
import UIKit // for UIAccessibility.post announcements

/// Demonstrates ACCESSIBLE STATE, as opposed to accessible NAME
/// (AccessibleNamePass) or ROLE (AccessibleRolePass). State tells VoiceOver
/// what condition a control is CURRENTLY in — selected, expanded, checked,
/// disabled, busy, invalid, playing — as distinct from what it's called or
/// what kind of control it is.
///
/// The recurring failure this file guards against: the state is conveyed
/// visually (a highlight, a chevron rotation, a red border, a dimmed
/// button) but never surfaced as an `accessibilityValue`, a trait, or an
/// announcement, so a VoiceOver user hears an identical string whether the
/// control is on or off.
struct AccessibleStatePass: View {

    @State private var selectedFilter = "Unread"
    @State private var isDetailsExpanded = false
    @State private var agreedToTerms = false
    @State private var isSubmitting = false
    @State private var email = ""
    @State private var emailError: String?
    @State private var isPlaying = false
    @State private var currentStep = 2

    private let filters = ["All", "Unread", "Flagged"]
    private let steps = ["Cart", "Shipping", "Payment", "Review"]

    private var isFormValid: Bool { !email.isEmpty && emailError == nil }

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Selected state — custom filter chips
                Section("Selected") {
                    HStack {
                        ForEach(filters, id: \.self) { filter in
                            let isSelected = selectedFilter == filter
                            Text(filter)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(isSelected ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                                .clipShape(Capsule())
                                .onTapGesture { selectedFilter = filter }
                                // The background tint is the ONLY visual cue.
                                // .isSelected is what carries that same
                                // information to VoiceOver ("Unread, selected,
                                // button").
                                .accessibilityAddTraits(
                                    isSelected ? [.isButton, .isSelected] : .isButton
                                )
                                .srcLine()
                        }
                    }
                }

                // MARK: Expanded / collapsed state — custom disclosure row
                Section("Expanded / Collapsed") {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Shipping details")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(isDetailsExpanded ? 90 : 0))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { isDetailsExpanded.toggle() }
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isButton)
                        // iOS exposes no dedicated expanded/collapsed trait,
                        // so the state rides on accessibilityValue. Without
                        // it the rotating chevron is invisible to VoiceOver.
                        .accessibilityValue(isDetailsExpanded ? "Expanded" : "Collapsed")
                        .accessibilityHint(isDetailsExpanded ? "Double tap to collapse" : "Double tap to expand")
                        .srcLine()

                        if isDetailsExpanded {
                            Text("Delivered in 5–7 business days.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // MARK: Checked state — custom checkbox
                Section("Checked") {
                    HStack {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        Text("I agree to the Terms of Service")
                    }
                    .onTapGesture { agreedToTerms.toggle() }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    // A native Toggle would announce "on"/"off" for free.
                    // A hand-built checkbox has to state it explicitly.
                    .accessibilityValue(agreedToTerms ? "Checked" : "Not checked")
                    .srcLine()
                }

                // MARK: Disabled state
                Section("Disabled") {
                    Button("Continue") { /* submit */ }
                        // .disabled() adds the .notEnabled trait automatically,
                        // so VoiceOver announces "Continue, dimmed, button".
                        // Never fake this with .opacity() alone.
                        .disabled(!isFormValid)
                        .accessibilityHint(
                            isFormValid
                            ? "Proceeds to shipping"
                            : "Unavailable until a valid email address is entered"
                        )
                        .srcLine()
                        // The hint explains WHY it's disabled — otherwise the
                        // user hears "dimmed" with no path to enabling it.
                }

                // MARK: Busy / loading state
                Section("Busy") {
                    Button {
                        isSubmitting = true
                        // A spinner appearing does not move VoiceOver focus,
                        // so the state change must be announced.
                        UIAccessibility.post(notification: .announcement, argument: "Submitting, please wait")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isSubmitting = false
                            UIAccessibility.post(notification: .announcement, argument: "Submitted successfully")
                        }
                    } label: {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .accessibilityHidden(true) // state is on the button, not the spinner
                            }
                            Text(isSubmitting ? "Submitting…" : "Submit")
                        }
                    }
                    .disabled(isSubmitting)
                    .accessibilityLabel("Submit")
                    .accessibilityValue(isSubmitting ? "Busy" : "")
                    .srcLine()
                }

                // MARK: Invalid / error state
                Section("Invalid") {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Email address", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .onChange(of: email) { _, newValue in
                                let wasValid = emailError == nil
                                emailError = newValue.contains("@") || newValue.isEmpty
                                    ? nil
                                    : "Enter a valid email address"
                                // Announce the transition into an error state —
                                // the red border below is purely visual.
                                if wasValid, let error = emailError {
                                    UIAccessibility.post(notification: .announcement, argument: error)
                                }
                            }
                            // "Required" belongs in the label; the error text
                            // belongs in the value so it's re-read on refocus.
                            .accessibilityLabel("Email address, required")
                            .accessibilityValue(emailError ?? email)
                            .srcLine()

                        if let emailError {
                            Text(emailError)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                // Already carried by the field's value — don't
                                // make VoiceOver users hear it twice.
                                .accessibilityHidden(true)
                        }
                    }
                    .padding(.vertical, 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(emailError == nil ? .clear : .red)
                    )
                }

                // MARK: Play / pause toggle state
                Section("Playing / Paused") {
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    }
                    // The LABEL describes the action, the VALUE describes the
                    // current state — keeping both stable avoids the classic
                    // "is 'Play' what it does or what it's doing?" ambiguity.
                    .accessibilityLabel(isPlaying ? "Pause" : "Play")
                    .accessibilityValue(isPlaying ? "Playing" : "Paused")
                    .srcLine()
                }

                // MARK: Current step in a progress tracker
                Section("Current") {
                    HStack {
                        ForEach(steps.indices, id: \.self) { index in
                            let isCurrent = index == currentStep
                            Text(steps[index])
                                .font(.caption)
                                .fontWeight(isCurrent ? .bold : .regular)
                                .foregroundStyle(isCurrent ? Color.accentColor : .secondary)
                                .frame(maxWidth: .infinity)
                                .onTapGesture { currentStep = index }
                                .accessibilityAddTraits(
                                    isCurrent ? [.isButton, .isSelected] : .isButton
                                )
                                // Position is state too — "step 3 of 4" is
                                // information the bold styling conveys
                                // visually and nothing else conveys otherwise.
                                .accessibilityValue("Step \(index + 1) of \(steps.count)")
                                .srcLine()
                        }
                    }
                }
            }
            .navigationTitle("Accessible State")
        }
    }
}

#Preview {
    AccessibleStatePass()
}
