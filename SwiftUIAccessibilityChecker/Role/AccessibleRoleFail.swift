import SwiftUI

/// Worst-case tier: this is not just missing roles — several controls are
/// given the WRONG role outright, actively misleading VoiceOver users
/// about how something behaves. A wrong role is often worse than no role,
/// because it sets an incorrect expectation instead of just an absent one.
/// Deliberately broken; reference only.
struct AccessibleRoleFail: View {

    @State private var isWifiOnlyFilterOn = false
    @State private var selectedShippingOption = 0
    @State private var brightness: Double = 0.5
    
    @Environment(\.openURL) private var openURL

    private let shippingOptions = ["Standard (5-7 days)", "Express (2-3 days)", "Overnight"]

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Custom button — WRONG role
                Section {
                    Text("Refresh")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.accentColor.opacity(0.15))
                        .clipShape(Capsule())
                        .onTapGesture { print("click")/* refresh action */ }
                        .srcLine()
                        // Actively wrong: tells VoiceOver this is
                        // definitely NOT interactive, despite the tap
                        // gesture right above it actually doing something.
                        .accessibilityAddTraits(.isButton)
                }

                // MARK: Section header — no header at all, no context
                Section {
                    Text("Wi-Fi, Bluetooth, and other radios")
                }

                // MARK: Custom link — WRONG role
                Section {
                    Text("View documentation")
                        .foregroundStyle(.blue)
                        .underline()
                        .onTapGesture {
                            if let url = URL(string: "https://www.apple.com/documentation") {
                                openURL(url)
                            }
                        }
                        .srcLine()
                        // Actively wrong: announced as "button" when it's
                        // really a link — a VoiceOver user familiar with
                        // link conventions gets the wrong mental model,
                        // e.g. expecting it to open in a new context vs.
                        // trigger an in-place action.
                        .accessibilityAddTraits(.isStaticText)
                        // FIX — correct role for link-like behavior:
                        // .accessibilityAddTraits(.isLink)
                }

                // MARK: Custom filter chip — no grouping, no role at all
                Section {
                    HStack {
                        Image(systemName: isWifiOnlyFilterOn ? "checkmark.square.fill" : "square")
                        Text("Wi-Fi Only")
                    }
                    .onTapGesture { isWifiOnlyFilterOn.toggle() }
                        .srcLine()
                    // No .accessibilityElement(children: .combine) and no
                    // traits — VoiceOver swipes through the checkbox image
                    // and the text as two separate, unrelated, non-
                    // interactive elements. Nothing indicates this can be
                    // tapped at all, let alone toggled.
                }

                // MARK: Custom radio rows — no grouping, no role, no state
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
                            .srcLine()
                        // Same problem as the filter chip: each row reads
                        // as plain, non-interactive text. Worse, the
                        // checkmark image (when present) reads as its own
                        // separate, unlabeled "checkmark" element with no
                        // connection to the row it belongs to.
                    }
                }

                // MARK: Custom adjustable dial — WRONG role
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
                        .srcLine()
                    // Actively wrong: marked as a simple button, implying
                    // one double-tap does something discrete — instead of
                    // a continuous control a VoiceOver user adjusts by
                    // swiping up/down. Double-tapping this does nothing,
                    // which reads as a broken button, not a working dial.
                    .accessibilityAddTraits(.isButton)
                }

                // MARK: Decorative icon — WRONG role
                Section {
                    Image(systemName: "sparkle")
                        .onTapGesture { /* hidden easter egg */ }
                        .srcLine()
                        // Actively wrong: implies a real, discoverable
                        // control exists here. A VoiceOver user who
                        // double-taps expecting a meaningful action gets
                        // nothing recognizable back.
                        .accessibilityAddTraits(.isButton)
                }
            }
        }
    }
}

#Preview {
    AccessibleRoleFail()
}

