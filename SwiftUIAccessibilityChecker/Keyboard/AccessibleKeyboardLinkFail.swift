import SwiftUI
 
struct AccessibleKeyboardLinkFail: View {
    @Environment(\.openURL) private var openURL
 
    private let url = URL(string: "https://www.w3.org/WAI/WCAG22/Understanding/keyboard.html")!
 
    var body: some View {
        NavigationStack {
            List {
                // MARK: - FAIL example
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Learn more about keyboard accessibility in our guide.")
                            .font(.body)
 
                        // Looks like a link, works on tap, announced as "Link"
                        // by VoiceOver, but keyboard cannot reach or activate it.
                        Text("Read the keyboard guide")
                            .font(.body)
                            .foregroundStyle(.blue)
                            .underline()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                openURL(url)          // Functional on touch
                            }
                            // Expose as a LINK, not a button
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("Read the keyboard guide")
                            .accessibilityRemoveTraits(.isButton)
                            .accessibilityAddTraits(.isLink)
                            .accessibilityAction {
                                openURL(url)          // VoiceOver double-tap still works
                            }
                            // Defect: removed from keyboard interaction
                            .accessibilityRespondsToUserInteraction(false) // skipped by Full Keyboard Access
                            .focusable(false)                              // skipped by Tab / arrow focus
                            .srcLine()
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Fail: Link not keyboard operable")
                } footer: {
                    Text("Tap works. VoiceOver announces “Link”. Keyboard focus never lands on it.")
                }
 
                // MARK: - PASS example
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Learn more about keyboard accessibility in our guide.")
                            .font(.body)
 
                        Link("Read the keyboard guide", destination: url)
                            .font(.body)
                            .underline()
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Pass: Native Link")
                } footer: {
                    Text("Reachable and activatable with Full Keyboard Access (Tab, then Space).")
                }
            }
            .navigationTitle("Link – Keyboard")
        }
    }
}
 
#Preview {
    AccessibleKeyboardLinkFail()
}
 
/*
TEST CASE
---------
ID:        Link not operable with keyboard
SC:        2.1.1 Keyboard (A)
Platform:  iOS 17+ / iPadOS 17+, SwiftUI
 
Preconditions:
   - Hardware keyboard connected (or Simulator with keyboard input).
   - Settings > Accessibility > Keyboards > Full Keyboard Access: ON.
 
Steps:
   1. Open the screen.
   2. Tap "Read the keyboard guide" in the Fail section -> URL opens (functional).
   3. Turn on VoiceOver, swipe to it -> announced as "Read the keyboard guide, link".
   4. Turn off VoiceOver. With Full Keyboard Access, press Tab / arrow keys
      through the screen.
   5. Try to reach and activate the Fail link with Space / Return.
 
Expected (pass): Link receives keyboard focus and opens the URL on Space.
Actual (fail):   Focus skips the link; it cannot be activated by keyboard.
 
Recommendation:
   Use SwiftUI `Link(_:destination:)`, or remove
   `.accessibilityRespondsToUserInteraction(false)` / `.focusable(false)`
   so the element participates in keyboard focus.
*/
