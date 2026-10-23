import SwiftUI

/// CUSTOM ACTION — Partial tier.
///
/// The drag has an alternative action; the pinch does not.
///
/// Elements covered (2):
///   1. Slide to dismiss — DragGesture + accessibilityAction  → BB40191 Pass
///   2. Pinch to zoom    — MagnificationGesture only          → BB40190 Fail
struct AccessibleCustomActionPartial: View {
    @State private var offset: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var angle: Angle = .zero

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Slide to dismiss")
                        .frame(maxWidth: .infinity, minHeight: 64)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .gesture(
                            DragGesture()
                                .onChanged { offset = $0.translation.width }
                                .onEnded { _ in offset = 0 }
                        )
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Dismiss")
                        .accessibilityAction(named: "Dismiss") { offset = 0 }
                        .srcLine()

                    Text("Pinch to zoom")
                        .frame(maxWidth: .infinity, minHeight: 64)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .gesture(
                            MagnificationGesture()
                                .onChanged { scale = $0 }
                        )
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("CustomActionPartial")
        }
    }
}

#Preview {
    AccessibleCustomActionPartial()
}
