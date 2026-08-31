import SwiftUI

/// Worst-case tier: the same hand-drawn clones as Partial, but with NO
/// accessibility wiring at all. Nothing here is a real Toggle/Slider/
/// Stepper/Picker — they're all custom shapes driven by tap/drag gestures
/// — and without a single accessibility modifier, VoiceOver either skips
/// them entirely or reads them as generic, unlabeled shapes with zero
/// indication of function or state. Deliberately broken; reference only.
struct AccessibleNativeRoleFail: View {

    @State private var notificationsOn = false
    @State private var volume: Double = 0.5
    @State private var quantity = 1
    @State private var selectedColorOption = "Blue"
    @State private var agreedToTerms = false

    private let colorOptions = ["Red", "Green", "Blue"]

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Custom switch — completely silent
                Section {
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
                    .accessibilityLabel("Notifications")
                    .srcLine()
                    // No accessibility modifiers at all — sighted users see
                    // it slide on/off; VoiceOver users don't know it exists.
                }

                // MARK: Custom slider — completely silent
                Section {
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
                    .srcLine()
                }

                // MARK: Custom stepper — unlabeled symbols
                Section {
                    HStack(spacing: 20) {
                        Text("−")
                            .font(.title2)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                            .onTapGesture { quantity = max(quantity - 1, 1) }

                        Text("\(quantity)")

                        Text("+")
                            .font(.title2)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                            .onTapGesture { quantity = min(quantity + 1, 10) }
                    }
                        .srcLine()
                    // VoiceOver reads three disconnected text glyphs:
                    // "minus", the number, "plus" — nothing indicates two
                    // of them are buttons or what they control.
                }

                // MARK: Custom segmented control — unlabeled colors
                Section {
                    HStack(spacing: 0) {
                        ForEach(colorOptions, id: \.self) { option in
                            Text(option)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(selectedColorOption == option ? Color.accentColor.opacity(0.2) : .clear)
                                .onTapGesture { selectedColorOption = option }
                        }
                    }
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color(.systemGray4)))
                        .srcLine()
                }

                // MARK: Custom checkbox — silent icon + text
                Section {
                    HStack {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        Text("I agree to the Terms of Service")
                    }
                    .onTapGesture { agreedToTerms.toggle() }
                        .srcLine()
                    // Not combined into one element either — VoiceOver
                    // swipes through the checkbox image and the agreement
                    // text as two separate, unrelated pieces, with the
                    // image announced only as "square" or "checkmark
                    // square fill" depending on state.
                }
            }
        }
    }
}

#Preview {
    AccessibleNativeRoleFail()
}
