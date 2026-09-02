import SwiftUI

/// Partial tier: every control's NAME/visible text is still present, but
/// the ROLE (accessibility trait) is simply omitted rather than set
/// correctly. Result: VoiceOver can still read the text, but misreports or
/// under-reports what kind of control it is — a button reads as static
/// text, a link reads as static text, a filter chip never announces its
/// selected state, radio rows never reveal which one is chosen, and the
/// adjustable dial is completely unreachable by VoiceOver's adjust gesture
/// even though a sighted user can drag it freely.
struct AccessibleRolePartial: View {

    @State private var isWifiOnlyFilterOn = false
    @State private var selectedShippingOption = 0
    @State private var brightness: Double = 0.5
    @Environment(\.openURL) private var openURL


    private let shippingOptions = ["Standard (5-7 days)", "Express (2-3 days)", "Overnight"]

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Custom button — role omitted
                Section {
                    Text("Refresh")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.accentColor.opacity(0.15))
                        .clipShape(Capsule())
                        .onTapGesture { /* refresh action */ }
                        .srcLine()
                        // No .isButton — VoiceOver reads "Refresh" as plain
                        // text, with no indication it's actionable.
                }

                // MARK: Section header — role omitted
                Section {
                    Text("Wi-Fi, Bluetooth, and other radios")
                } header: {
                    Text("Connectivity")
                        // No .isHeader — looks like a heading, isn't one
                        // for VoiceOver's rotor.
                }

                // MARK: Custom link — role omitted
                Section {
                    Text("View documentation")
                        .foregroundStyle(.blue)
                        .underline()
                        //.onTapGesture {
                            .onTapGesture {
                                if let url = URL(string: "https://www.apple.com/documentation") {
                                    openURL(url)
                                }
                            }
                       // }
                        .srcLine()
                        .accessibilityAddTraits(.isLink)
                        // No .isLink — VoiceOver has no idea this behaves
                        // differently from any other line of text.
                }

                // MARK: Custom filter chip — role incomplete
                Section {
                    HStack {
                        Image(systemName: isWifiOnlyFilterOn ? "checkmark.square.fill" : "square")
                        Text("Wi-Fi Only")
                    }
                    .onTapGesture { isWifiOnlyFilterOn.toggle() }
                    .accessibilityElement(children: .combine)
                        .srcLine()
                    // .isButton is present, so VoiceOver knows it's
                    // actionable — but .isSelected is never applied, so
                    // toggling it on/off is invisible to VoiceOver users.
                    .accessibilityAddTraits(.isButton)
                }

                // MARK: Custom radio-style rows — role incomplete
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
                        // Every row is a button, but none is ever marked
                        // .isSelected — VoiceOver users can't tell which
                        // shipping option is currently chosen.
                        .accessibilityAddTraits(.isButton)
                    }
                }

                // MARK: Custom adjustable dial — role omitted entirely
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
                    // No .accessibilityAdjustableAction — VoiceOver focuses
                    // this element and reads its value, but swiping up/down
                    // does nothing. The drag gesture that sighted users rely
                    // on is simply unreachable under VoiceOver.
                }

                // MARK: Decorative icon — left at SwiftUI's default
                Section {
                    Image(systemName: "sparkle")
                        .onTapGesture { /* hidden easter egg */ }
                        .srcLine()
                        // Not hidden — SwiftUI's Image is an accessibility
                        // element by default with an implicit .isImage
                        // trait, so VoiceOver announces "sparkle, image":
                        // harmless, but noisy and unhelpful for a pure
                        // decoration nobody needs to hear about.
                }
            }
            .navigationTitle("Accessible Roles (Partial)")
        }
    }
}

#Preview {
    AccessibleRolePartial()
}
