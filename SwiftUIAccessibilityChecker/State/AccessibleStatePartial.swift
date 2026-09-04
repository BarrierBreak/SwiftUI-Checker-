import SwiftUI
import UIKit

/// Partial tier: every control still has a correct NAME and a correct ROLE
/// — VoiceOver reads them and knows they're buttons — but the STATE is
/// either missing, stale, or conveyed in a way that only works for sighted
/// users. This is the hardest tier to catch in code review, because each
/// element already carries accessibility modifiers and looks "done".
///
/// The specific gaps, in order:
/// chips have no .isSelected, the disclosure row never reports
/// expanded/collapsed, the checkbox has a hardcoded value that never syncs,
/// the notifications row's value was copied from a sibling control and
/// still tracks that control's state instead of its own, the Wi-Fi row's
/// value is read through a computed property a static scan can't see
/// inside of (genuinely ambiguous — flagged for manual review, not as a
/// confirmed defect), the disabled button is only visually dimmed, the
/// busy state is never announced, the error message is orphaned from the
/// field it describes, the play button's label and value contradict each
/// other, and the step tracker's current position is bold-only.
struct AccessibleStatePartial: View {

    @State private var selectedFilter = "Unread"
    @State private var isDetailsExpanded = false
    @State private var agreedToTerms = false
    @State private var notificationsEnabled = false
    @State private var wifiEnabled = false
    @State private var isSubmitting = false
    @State private var email = ""
    @State private var emailError: String?
    @State private var isPlaying = false
    @State private var currentStep = 2

    private let filters = ["All", "Unread", "Flagged"]
    private let steps = ["Cart", "Shipping", "Payment", "Review"]

    private var isFormValid: Bool { !email.isEmpty && emailError == nil }
    private var wifiStatusText: String { wifiEnabled ? "On" : "Off" }

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Selected state — trait omitted
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
                                // Bug: role is right, state is absent. All
                                // three chips read "…, button" identically,
                                // so the current filter is unknowable.
                                .accessibilityAddTraits(.isButton)
                                .srcLine()
                        }
                    }
                }

                // MARK: Expanded / collapsed — no value
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
                        .srcLine()
                        // Bug: no accessibilityValue. The rotating chevron is
                        // the only expanded/collapsed cue, and rotation is
                        // not exposed to the accessibility tree at all.

                        if isDetailsExpanded {
                            Text("Delivered in 5–7 business days.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // MARK: Checked state — value never syncs
                Section("Checked") {
                    HStack {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        Text("I agree to the Terms of Service")
                    }
                    .onTapGesture { agreedToTerms.toggle() }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    // Bug: hardcoded literal instead of reading agreedToTerms.
                    // VoiceOver insists it's unchecked even after the user
                    // checks it — worse than silence, because it's confidently
                    // wrong and the user has no reason to doubt it.
                    .accessibilityValue("Not checked")
                    .srcLine()
                }

                // MARK: Enabled state — value tracks the wrong control
                Section("Enabled") {
                    HStack {
                        Image(systemName: notificationsEnabled ? "bell.fill" : "bell.slash")
                        Text("Notifications")
                    }
                    .onTapGesture { notificationsEnabled.toggle() }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    // Bug: copied from the "Checked" row above and never
                    // repointed — this reads agreedToTerms, not
                    // notificationsEnabled. The row's own tap handler
                    // toggles the right property, but VoiceOver's
                    // announced value is silently driven by a different
                    // control's state, so it never changes no matter how
                    // many times this control is actually tapped.
                    .accessibilityValue(agreedToTerms ? "Enabled" : "Disabled")
                    .srcLine()
                }

                // MARK: Connected state — value read through a computed property
                Section("Connected") {
                    HStack {
                        Image(systemName: wifiEnabled ? "wifi" : "wifi.slash")
                        Text("Wi-Fi")
                    }
                    .onTapGesture { wifiEnabled.toggle() }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    // Ambiguous, not a confirmed bug: wifiStatusText correctly
                    // reads wifiEnabled, but nothing on this line proves that —
                    // a static scan sees a bare property reference, not the
                    // ternary itself, and cannot see inside the property's own
                    // implementation to confirm it actually tracks this
                    // control's own toggled identifier.
                    .accessibilityValue(wifiStatusText)
                    .srcLine()
                }

                // MARK: Disabled state — visual only
                Section("Disabled") {
                    Button("Continue") {
                        guard isFormValid else { return }
                    }
                    // Bug: dimmed with opacity instead of .disabled(). The
                    // button still reports as fully enabled, so VoiceOver
                    // users double-tap an active-sounding control and get
                    // nothing back, with no explanation anywhere.
                    .opacity(isFormValid ? 1.0 : 0.4)
                    .srcLine()
                }

                // MARK: Busy state — never announced
                Section("Busy") {
                    Button {
                        isSubmitting = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isSubmitting = false
                        }
                    } label: {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                            }
                            Text(isSubmitting ? "Submitting…" : "Submit")
                        }
                    }
                    .srcLine()
                    // Bug: no announcement on entering or leaving the busy
                    // state. Focus stays on the button, so unless the user
                    // happens to re-read it they never learn anything is in
                    // flight — or that it finished.
                }

                // MARK: Invalid state — error text is orphaned
                Section("Invalid") {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Email address", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .onChange(of: email) { _, newValue in
                                emailError = newValue.contains("@") || newValue.isEmpty
                                    ? nil
                                    : "Enter a valid email address"
                            }
                            .srcLine()
                        // Bug: nothing ties the error to the field. The
                        // required-ness is never stated either.

                        if let emailError {
                            Text(emailError)
                                .font(.footnote)
                                .foregroundStyle(.red)
                            // Bug: reachable only by swiping forward PAST the
                            // field. A user who tabs straight from this field
                            // to the next control never hears it, and the red
                            // border is a colour-only cue on top of that.
                        }
                    }
                    .padding(.vertical, 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(emailError == nil ? .clear : .red)
                    )
                }

                // MARK: Play / pause — state collapsed into the label
                Section("Playing / Paused") {
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    }
                    // Bug: the label flips to describe the STATE rather than
                    // the action, and there's no value to disambiguate. The
                    // user hears "Playing, button" and cannot tell whether
                    // double-tapping starts or stops playback.
                    .accessibilityLabel(isPlaying ? "Playing" : "Paused")
                    .srcLine()
                }

                // MARK: Current step — bold-only
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
                                .accessibilityAddTraits(.isButton)
                                .srcLine()
                            // Bug: no .isSelected and no positional value.
                            // Weight and colour carry the whole message, and
                            // neither reaches the accessibility tree.
                        }
                    }
                }
            }
            .navigationTitle("Accessible State (Partial)")
        }
    }
}

#Preview {
    AccessibleStatePartial()
}
