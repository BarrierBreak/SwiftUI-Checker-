import SwiftUI

/// FOCUS INDICATOR — Pass tier.
///
/// Every field draws a focus ring that is easy to see (3:1 or better against the page) and is
/// more than a colour: a heavy stroke, or a shadow. Nothing is reported.
///
/// A SwiftUI ring is an overlay stroke that appears while the field is `.focused`. It is drawn
/// in a display list with no layer to read at runtime, so it is judged from the source.
///
/// Elements covered (3) — none is a defect:
///   1. Dark 2pt ring          — #1A1A1A, 17:1
///   2. Blue 3pt ring          — #0B5FA5, 6.6:1
///   3. Dark hairline + shadow — 1pt #1A1A1A, with a shadow as a second cue
struct AccessibleFocusPass: View {

    private enum Field: Hashable {
        case f0
        case f1
        case f2
    }

    @FocusState private var focus: Field?
    @State private var text0 = ""
    @State private var text1 = ""
    @State private var text2 = ""

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
                                .stroke(focus == .f1 ? Color(hex: "#0B5FA5") : Color.clear, lineWidth: 3)
                        )
                        .srcLine()

                    TextField("Postcode", text: $text2)
                        .padding(12)
                        .focused($focus, equals: .f2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focus == .f2 ? Color(hex: "#1A1A1A") : Color.clear, lineWidth: 1)
                        .shadow(color: .black.opacity(0.4), radius: 4)
                        )
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("Focus (Pass)")
        }
    }
}

#Preview {
    AccessibleFocusPass()
}
