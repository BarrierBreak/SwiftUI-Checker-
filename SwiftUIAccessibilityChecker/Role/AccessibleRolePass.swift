import SwiftUI

/// Demonstrates ACCESSIBLE ROLE (SwiftUI accessibility trait), as opposed to
/// accessible NAME (AccessibleNamePass/Partial/Fail). Role tells VoiceOver
/// WHAT KIND of control something is — button, link, header, selected,
/// adjustable — independent of what it's called. Every custom (non-native)
/// control here gets the correct trait for how it behaves.
struct AccessibleRolePass: View {

    @State private var isWifiOnlyFilterOn = false
    @State private var selectedShippingOption = 0
    @State private var brightness: Double = 0.5

    private let shippingOptions = ["Standard (5-7 days)", "Express (2-3 days)", "Overnight"]

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Custom button (not a real SwiftUI Button)
                Section {
                    Text("Refresh")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.accentColor.opacity(0.15))
                        .clipShape(Capsule())
                        .onTapGesture { /* refresh action */ }
                        .srcLine()
                        // Correct role: VoiceOver announces "Refresh, button"
                        // and offers the standard activate gesture/hint.
                        .accessibilityAddTraits(.isButton)
                }

                // MARK: Section header role
                Section {
                    Text("Wi-Fi, Bluetooth, and other radios")
                } header: {
                    Text("Connectivity")
                        // Correct role: rotor-navigable as a heading.
                        .accessibilityAddTraits(.isHeader)
                }

                // MARK: Custom link (not SwiftUI's Link view)
                Section {
                    Text("View documentation")
                        .foregroundStyle(.blue)
                        .underline()
                        .onTapGesture { /* open URL */ }
                        .srcLine()
                        // Correct role: VoiceOver announces "View documentation,
                        // link" instead of misrepresenting it as a button.
                        .accessibilityAddTraits(.isLink)
                }

                // MARK: Custom filter chip / checkbox
                Section {
                    HStack {
                        Image(systemName: isWifiOnlyFilterOn ? "checkmark.square.fill" : "square")
                        Text("Wi-Fi Only")
                    }
                    .onTapGesture { isWifiOnlyFilterOn.toggle() }
                    .accessibilityElement(children: .combine)
                        .srcLine()
                    // Correct role: button trait so VoiceOver knows it's
                    // actionable, PLUS .isSelected reflecting current state —
                    // both the role AND the state are conveyed.
                    .accessibilityAddTraits(isWifiOnlyFilterOn ? [.isButton, .isSelected] : .isButton)
                    .accessibilityValue(isWifiOnlyFilterOn ? "On" : "Off")
                }

                // MARK: Custom radio-style single-select rows
                Section {
                    ForEach(shippingOptions.indices, id: \.self) { index in
                        let isSelected = selectedShippingOption == index
                        HStack {
                            Text(shippingOptions[index])
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark")
                            }
                        }
                        .onTapGesture { selectedShippingOption = index }
                        .accessibilityElement(children: .combine)
                            .srcLine()
                        // Correct role: each row is a button, and .isSelected
                        // marks exactly one as the current choice — mirrors
                        // how a native radio group would be perceived.
                        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
                    }
                }

                // MARK: Custom adjustable dial (hand-built, not a Slider)
                Section {
                    ZStack {
                        Circle().stroke(Color.gray.opacity(0.3), lineWidth: 6)
                        Circle()
                            .trim(from: 0, to: brightness)
                            .stroke(Color.yellow, lineWidth: 6)
                            .rotationEffect(.degrees(-90))
                    }
                    .frame(width: 60, height: 60)
                    .gesture(
                        DragGesture(minimumDistance: 0).onChanged { value in
                            brightness = min(max(value.location.x / 60, 0), 1)
                        }
                    )
                    .accessibilityElement()
                    .accessibilityLabel("Brightness")
                    .accessibilityValue("\(Int(brightness * 100)) percent")
                        .srcLine()
                    // Correct role: this modifier itself confers the
                    // adjustable role — VoiceOver users swipe up/down to
                    // change brightness instead of needing the drag gesture,
                    // which they can't perform the same way sighted users do.
                    .accessibilityAdjustableAction { direction in
                        switch direction {
                        case .increment: brightness = min(brightness + 0.1, 1)
                        case .decrement: brightness = max(brightness - 0.1, 0)
                        default: break
                        }
                    }
                }

                // MARK: Decorative icon — correctly given NO role
                Section {
                    Image(systemName: "sparkle")
                        .onTapGesture { /* hidden easter egg, not core functionality */ }
                        .srcLine()
                        // Correct role: nothing essential here, so it's
                        // removed from the accessibility tree entirely
                        // instead of confusing VoiceOver users with a
                        // decoration that appears interactive.
                        .accessibilityHidden(true)
                }
            }
            .navigationTitle("Accessible Roles")
        }
    }
}

#Preview {
    AccessibleRolePass()
}
