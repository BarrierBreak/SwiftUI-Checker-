import SwiftUI

/// FOCUS OBSCURED — Fail tier.
///
/// Each button has a "Chat with us" banner drawn on top of it in a ZStack, so the control — and
/// any focus ring it draws — is hidden. Each is reported as BB40075 "Check if focus indicator is
/// obscured by another element", a Validate, because only a person can say whether the covered
/// control is meant to be reachable.
///
/// SwiftUI's accessibility elements and their frames are read at runtime; no linter check is
/// involved.
///
/// Elements covered (2) — both are reported:
///   1. Save — fully covered by the banner   → BB40075 Validate
///   2. Next — fully covered by the banner   → BB40075 Validate
struct AccessibleFocusObscuredFail: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ZStack {
                        Button("Save") {}
                            .buttonStyle(.borderedProminent)
                            .srcLine()
                        Text("Chat with us — we are online")
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Color.yellow.opacity(0.95))
                            .srcLine()
                    }
                    .frame(height: 90)

                    ZStack {
                        Button("Next") {}
                            .buttonStyle(.borderedProminent)
                            .srcLine()
                        Text("Chat with us — we are online")
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Color.yellow.opacity(0.95))
                            .srcLine()
                    }
                    .frame(height: 90)
                }
                .padding(24)
            }
            .navigationTitle("FocusObscuredFail")
        }
    }
}

#Preview {
    AccessibleFocusObscuredFail()
}
