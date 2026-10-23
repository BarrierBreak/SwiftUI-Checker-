import SwiftUI

/// FOCUS INDICATOR — Fail tier.
///
/// Every field's focus ring has one of the two defects, and one has both.
///
///   BB40117  "Insufficient color contrast for focus indicator"  — under 3:1
///   BB40119  "Color alone used to indicate focus"               — a hairline, no shadow
///
/// Elements covered (4) — every one fails:
///   1. Light 2pt ring       — #CFCFCF, 1.5:1                         → BB40117
///   2. Grey 2pt ring        — #A0A0A0, 2.6:1                         → BB40117
///   3. Dark hairline        — 1pt #1A1A1A: easy to see, but a line   → BB40119
///   4. Light hairline       — 1pt #CFCFCF: both defects              → BB40117 and BB40119
struct AccessibleFocusFail: View {

    private enum Field: Hashable {
        case f0
        case f1
        case f2
        case f3
    }

    @FocusState private var focus: Field?
    @State private var text0 = ""
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextField("Email address", text: $text0)
                        .padding(12)
                        .focused($focus, equals: .f0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focus == .f0 ? Color(hex: "#CFCFCF") : Color.clear, lineWidth: 2)
                        )
                        .srcLine()

                    TextField("Phone number", text: $text1)
                        .padding(12)
                        .focused($focus, equals: .f1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focus == .f1 ? Color(hex: "#A0A0A0") : Color.clear, lineWidth: 2)
                        )
                        .srcLine()

                    TextField("Postcode", text: $text2)
                        .padding(12)
                        .focused($focus, equals: .f2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focus == .f2 ? Color(hex: "#1A1A1A") : Color.clear, lineWidth: 1)
                        )
                        .srcLine()

                    TextField("Company", text: $text3)
                        .padding(12)
                        .focused($focus, equals: .f3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focus == .f3 ? Color(hex: "#CFCFCF") : Color.clear, lineWidth: 1)
                        )
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Focus (Fail)")
        }
    }
}

#Preview {
    AccessibleFocusFail()
}
