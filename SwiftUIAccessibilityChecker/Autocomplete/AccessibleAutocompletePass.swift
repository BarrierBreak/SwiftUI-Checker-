import SwiftUI

/// AUTOCOMPLETE — Pass tier.
///
/// Both fields declare what they collect with textContentType.
///
/// Elements covered (2):
///   1. Email address — .textContentType(.emailAddress)  → BB40092 Pass
///   2. Password      — .textContentType(.password)      → BB40092 Pass
struct AccessibleAutocompletePass: View {
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
                    SecureField("Password", text: $f1)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.password)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("AutocompletePass")
        }
    }
}

#Preview {
    AccessibleAutocompletePass()
}
