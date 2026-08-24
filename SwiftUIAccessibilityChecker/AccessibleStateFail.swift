import SwiftUI
import UIKit

/// Worst-case tier: every gap from Partial remains, and several controls
/// now report state that is actively WRONG rather than merely absent —
/// permanently inverted values, a selected trait pinned to the wrong item,
/// an enabled-sounding button that does nothing, and a busy state that
/// announces completion the moment work starts. Wrong state is worse than
/// missing state: missing state makes a user look harder, wrong state
/// makes them stop looking. Deliberately broken; reference only.
struct AccessibleStateFail: View {

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

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Selected state — pinned to the wrong chip
                Section {
                    HStack {
                        ForEach(filters, id: \.self) { filter in
                            let isSelected = selectedFilter == filter
                            Text(filter)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(isSelected ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                                .clipShape(Capsule())
                                .onTapGesture { selectedFilter = filter }
                                // Actively wrong: the first chip is always
                                // marked selected regardless of the real
                                // selection, so VoiceOver and the screen
                                // disagree about which filter is active.
                                .accessibilityAddTraits(
                                    filter == filters.first ? [.isButton, .isSelected] : .isButton
                                )
                            // FIX — derive from the actual state:
                            // .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
                        }
                    }
                }

                // MARK: Expanded / collapsed — hidden from VoiceOver entirely
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Shipping details")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(isDetailsExpanded ? 90 : 0))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { isDetailsExpanded.toggle() }
                        // Actively wrong: the whole control is removed from
                        // the accessibility tree, so the collapsed content
                        // below it can never be revealed by a VoiceOver user.
                        .accessibilityHidden(true)
                        // FIX — expose it as a button and report its state:
                        // .accessibilityElement(children: .combine)
                        // .accessibilityAddTraits(.isButton)
                        // .accessibilityValue(isDetailsExpanded ? "Expanded" : "Collapsed")

                        if isDetailsExpanded {
                            Text("Delivered in 5–7 business days.")
                                .font(.footnote)
                        }
                    }
                }

                // MARK: Checked state — permanently inverted
                Section {
                    HStack {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        Text("I agree to the Terms of Service")
                    }
                    .onTapGesture { agreedToTerms.toggle() }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    // Actively wrong: the ternary is backwards. A user who
                    // has NOT agreed is told they have — a consent checkbox
                    // lying about consent.
                    .accessibilityValue(agreedToTerms ? "Not checked" : "Checked")
                    // FIX — .accessibilityValue(agreedToTerms ? "Checked" : "Not checked")
                }

                // MARK: Disabled state — inert but announced as available
                Section {
                    Button {
                        // Guarded internally; nothing happens, silently.
                    } label: {
                        Text("Continue")
                    }
                    // Actively wrong: the button is dead code for most of the
                    // form's life, yet reports as a normal enabled control.
                    // No dimmed trait, no hint, no feedback on activation.
                    // FIX — .disabled(!isFormValid) plus a hint explaining
                    // what would enable it.
                }

                // MARK: Busy state — announces the opposite of what happened
                Section {
                    Button {
                        isSubmitting = true
                        // Actively wrong: fired at the START of the work, so
                        // the user is told it finished while it's still in
                        // flight — and gets nothing when it actually does.
                        UIAccessibility.post(notification: .announcement, argument: "Submitted successfully")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isSubmitting = false
                        }
                    } label: {
                        ProgressView()
                    }
                    // Icon-only trigger with no label either — reads as a
                    // bare "progress indicator" with no action attached.
                    // FIX — announce "Submitting" on entry and the result on
                    // completion, and label the button.
                }

                // MARK: Invalid state — error suppressed
                Section {
                    TextField("", text: $email)
                        .onChange(of: email) { _, newValue in
                            emailError = newValue.contains("@") || newValue.isEmpty
                                ? nil
                                : "Enter a valid email address"
                        }
                        // Actively wrong: the field is unlabeled, the error
                        // text is never rendered at all, and the value is
                        // overwritten with a placeholder that erases both the
                        // entered text and the error.
                        .accessibilityValue("Empty")
                    // FIX — label the field (including "required"), and put
                    // the error into the value so it re-reads on refocus:
                    // .accessibilityLabel("Email address, required")
                    // .accessibilityValue(emailError ?? email)
                }

                // MARK: Play / pause — static label, no state at all
                Section {
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    }
                    // Actively wrong: a fixed label that stops being true the
                    // instant playback starts, and no value to correct it.
                    .accessibilityLabel("Play")
                    // FIX — flip the label with the action and carry the
                    // state in a value:
                    // .accessibilityLabel(isPlaying ? "Pause" : "Play")
                    // .accessibilityValue(isPlaying ? "Playing" : "Paused")
                }

                // MARK: Current step — every step marked current
                Section {
                    HStack {
                        ForEach(steps.indices, id: \.self) { index in
                            let isCurrent = index == currentStep
                            Text(steps[index])
                                .font(.caption)
                                .fontWeight(isCurrent ? .bold : .regular)
                                .frame(maxWidth: .infinity)
                                .onTapGesture { currentStep = index }
                                // Actively wrong: all four steps claim to be
                                // selected, which is indistinguishable from
                                // none of them being selected — except it
                                // also suggests a multi-select control.
                                .accessibilityAddTraits([.isButton, .isSelected])
                            // FIX — .accessibilityAddTraits(isCurrent ? [.isButton, .isSelected] : .isButton)
                            // .accessibilityValue("Step \(index + 1) of \(steps.count)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AccessibleStateFail()
}
