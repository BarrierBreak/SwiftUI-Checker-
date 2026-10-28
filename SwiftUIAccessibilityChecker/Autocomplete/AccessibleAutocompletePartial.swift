import SwiftUI

/// AUTOCOMPLETE — Partial tier.
///
/// One field declares its purpose and one does not.
///
/// Elements covered (2):
///   1. Email address — .textContentType(.emailAddress)  → BB40092 Pass
///   2. Phone number  — phone keyboard, no content type  → BB40091 Fail
struct AccessibleAutocompletePartial: View {
    @State private var f0 = ""
    @State private var f1 = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextField("Email address", text: $f0)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .srcLine()
                    TextField("Phone number", text: $f1)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("AutocompletePartial")
        }
    }
}

#Preview {
    AccessibleAutocompletePartial()
}
