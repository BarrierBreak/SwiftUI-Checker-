import SwiftUI

/// AUTOCOMPLETE — Fail tier.
///
/// Both fields collect personal data but declare no textContentType.
///
/// Elements covered (2):
///   1. Email address — email keyboard, no content type  → BB40091 Fail
///   2. Phone number  — phone keyboard, no content type  → BB40091 Fail
struct AccessibleAutocompleteFail: View {
    @State private var f0 = ""
    @State private var f1 = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextField("Email address", text: $f0)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .srcLine()
                    TextField("Phone number", text: $f1)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("AutocompleteFail")
        }
    }
}

#Preview {
    AccessibleAutocompleteFail()
}
