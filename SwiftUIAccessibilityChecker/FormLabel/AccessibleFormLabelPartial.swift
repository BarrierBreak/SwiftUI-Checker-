import SwiftUI

/// FORM LABEL — Partial tier.
///
/// One field has a visible label; one relies on its placeholder.
///
/// Elements covered (2):
///   1. Email — TextField, Text label above     → no BB40034 row
///   2. Phone — TextField, placeholder only     → BB40034 Fail
struct AccessibleFormLabelPartial: View {
    @State private var email = ""
    @State private var phone = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                        TextField("name@example.com", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .srcLine()
                    }

                    TextField("Phone", text: $phone)
                        .textFieldStyle(.roundedBorder)
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("FormLabelPartial")
        }
    }
}

#Preview {
    AccessibleFormLabelPartial()
}
