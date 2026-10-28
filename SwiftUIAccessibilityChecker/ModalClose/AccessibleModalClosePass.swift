import SwiftUI

/// MODAL CLOSE — Pass tier.
///
/// The dialog has a Close button.
///
/// Elements covered (1):
///   1. Save dialog — Save and Close buttons  → BB40114 Pass (family modalClose); nothing in family modal
struct AccessibleModalClosePass: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Save changes")
                            .font(.headline)
                        Button("Save") {}
                        Button("Close") {}
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.15))
                    .accessibilityAddTraits(.isModal)
                    .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("ModalClosePass")
        }
    }
}

#Preview {
    AccessibleModalClosePass()
}
