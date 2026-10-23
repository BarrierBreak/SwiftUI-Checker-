import SwiftUI

/// FOCUS INDICATOR — Partial tier.
///
/// Some rings are fine and some are not.
///
/// Elements covered (4):
///   1. Dark 2pt ring       — #1A1A1A                                 → nothing
///   2. Light 2pt ring      — #CFCFCF, 1.5:1                          → BB40117 Fail
///   3. Dark hairline       — 1pt #1A1A1A, no second cue              → BB40119 Fail
///   4. Blue 3pt ring       — #0B5FA5                                 → nothing
struct AccessibleFocusPartial: View {

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
                                .stroke(focus == .f0 ? Color(hex: "#1A1A1A") : Color.clear, lineWidth: 2)
                        )
                        .srcLine()

                    TextField("Phone number", text: $text1)
                        .padding(12)
                        .focused($focus, equals: .f1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focus == .f1 ? Color(hex: "#CFCFCF") : Color.clear, lineWidth: 2)
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
                                .stroke(focus == .f3 ? Color(hex: "#0B5FA5") : Color.clear, lineWidth: 3)
                        )
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Focus (Partial)")
        }
    }
}

#Preview {
    AccessibleFocusPartial()
}
