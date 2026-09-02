import SwiftUI

/// Partial tier: every native control from AccessibleNativeRolePass is
/// replaced with a hand-drawn visual clone (built for custom styling
/// designers often want). Each clone gets SOME accessibility wiring — a
/// label, a button trait — but the piece that requires the developer to
/// manually re-derive what the native control gave for free (a live
/// value, a selected state, an adjustable action) is missing or stale.
/// The result LOOKS accessible in code review but is functionally broken
/// for VoiceOver users in a specific, easy-to-miss way.
struct AccessibleNativeRolePartial: View {

    @State private var notificationsOn = false
    @State private var volume: Double = 0.5
    @State private var quantity = 1
    @State private var selectedColorOption = "Blue"
    @State private var agreedToTerms = false

    private let colorOptions = ["Red", "Green", "Blue"]

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Custom switch — value never syncs
                Section("Toggle") {
                    ZStack(alignment: notificationsOn ? .trailing : .leading) {
                        Capsule()
                            .fill(notificationsOn ? Color.green : Color(.systemGray4))
                            .frame(width: 51, height: 31)
                        Circle()
                            .fill(.white)
                            .frame(width: 27, height: 27)
                            .padding(2)
                            .shadow(radius: 1)
                    }
                    .onTapGesture { notificationsOn.toggle() }
                    .accessibilityElement()
                    .accessibilityLabel("Enable Notifications")
                    .accessibilityAddTraits(.isButton)
                        .srcLine()
                    // Bug: hardcoded instead of reading notificationsOn —
                    // VoiceOver always announces "Off" no matter what the
                    // switch visually shows.
                    .accessibilityValue("Off")
                }

                // MARK: Custom slider — not adjustable
                Section("Slider") {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color(.systemGray4)).frame(height: 4)
                            Capsule().fill(Color.accentColor)
                                .frame(width: geometry.size.width * volume, height: 4)
                            Circle().fill(.white).shadow(radius: 1)
                                .frame(width: 20, height: 20)
                                .offset(x: geometry.size.width * volume - 10)
                        }
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0).onChanged { value in
                                volume = min(max(value.location.x / geometry.size.width, 0), 1)
                            }
                        )
                    }
                    .frame(height: 20)
                    .accessibilityElement()
                    .accessibilityLabel("Volume")
                    .accessibilityValue("\(Int(volume * 100)) percent")
                        .srcLine()
                    // Bug: no .accessibilityAdjustableAction — VoiceOver
                    // reports the current value but swiping up/down to
                    // change it does nothing. The drag gesture that
                    // sighted users rely on is unreachable under VoiceOver.
                }

                // MARK: Custom stepper — buttons work, count is silent
                Section("Stepper") {
                    HStack(spacing: 20) {
                        Text("−")
                            .font(.title2)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                            .onTapGesture { quantity = max(quantity - 1, 1) }
                            .accessibilityAddTraits(.isButton)
                            .accessibilityLabel("Decrease quantity")

                        Text("\(quantity)")

                        Text("+")
                            .font(.title2)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                            .onTapGesture { quantity = min(quantity + 1, 10) }
                            .accessibilityAddTraits(.isButton)
                            .accessibilityLabel("Increase quantity")
                    }
                        .srcLine()
                    // Bug: the two buttons work and are individually
                    // labeled, but the current quantity Text in the middle
                    // has no accessibilityValue tying it to either button —
                    // a VoiceOver user has to manually swipe to a third,
                    // disconnected element to hear the count at all.
                }

                // MARK: Custom segmented control — selection is invisible
                Section("Segmented Picker") {
                    HStack(spacing: 0) {
                        ForEach(colorOptions, id: \.self) { option in
                            Text(option)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(selectedColorOption == option ? Color.accentColor.opacity(0.2) : .clear)
                                .onTapGesture { selectedColorOption = option }
                                .accessibilityAddTraits(.isButton)
                            // Bug: no .isSelected — every segment reads as
                            // just "button", so a VoiceOver user can't tell
                            // which color is currently chosen.
                        }
                    }
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color(.systemGray4)))
                        .srcLine()
                }

                // MARK: Custom checkbox — button but no state
                Section("Checkbox-style Toggle") {
                    HStack {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        Text("I agree to the Terms of Service")
                    }
                    .onTapGesture { agreedToTerms.toggle() }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                        .srcLine()
                    // Bug: no accessibilityValue at all — VoiceOver knows
                    // this is tappable but never announces agreed/not
                    // agreed, unlike the native Toggle which always does.
                }
            }
            .navigationTitle("Native Controls (Partial)")
        }
    }
}

#Preview {
    AccessibleNativeRolePartial()
}
