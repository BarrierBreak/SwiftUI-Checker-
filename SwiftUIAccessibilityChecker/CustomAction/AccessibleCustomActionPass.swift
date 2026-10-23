import SwiftUI

/// CUSTOM ACTION — Pass tier.
///
/// Drag, pinch and rotate gestures, each with an `.accessibilityAction` that does the same thing
/// for VoiceOver and Switch Control. Judged from source (SWIFTUI_GESTURE_CUSTOM_ACTION).
///
/// Elements covered (3) — every one passes:
///   1. Slide to dismiss — DragGesture + accessibilityAction          → BB40191 Pass
///   2. Pinch to zoom    — MagnificationGesture + accessibilityAction → BB40191 Pass
///   3. Rotate photo     — RotationGesture + accessibilityAction      → BB40191 Pass
struct AccessibleCustomActionPass: View {
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
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Zoom in")
                        .accessibilityAction(named: "Zoom in") { offset = 0 }
                        .srcLine()

                    Text("Rotate photo")
                        .frame(maxWidth: .infinity, minHeight: 64)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .gesture(
                            RotationGesture()
                                .onChanged { angle = $0 }
                        )
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Rotate")
                        .accessibilityAction(named: "Rotate") { offset = 0 }
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("CustomActionPass")
        }
    }
}

#Preview {
    AccessibleCustomActionPass()
}
