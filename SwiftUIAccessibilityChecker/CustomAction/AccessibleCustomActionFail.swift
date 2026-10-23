import SwiftUI

/// CUSTOM ACTION — Fail tier.
///
/// Drag, pinch and rotate gestures with nothing for a screen-reader or switch user to do instead.
/// Judged from source (SWIFTUI_GESTURE_NO_CUSTOM_ACTION).
///
/// Elements covered (3) — every one fails:
///   1. Slide to dismiss — DragGesture only          → BB40190 Fail
///   2. Pinch to zoom    — MagnificationGesture only → BB40190 Fail
///   3. Rotate photo     — RotationGesture only      → BB40190 Fail
struct AccessibleCustomActionFail: View {
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

                    Text("Rotate photo")
                        .frame(maxWidth: .infinity, minHeight: 64)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .gesture(
                            RotationGesture()
                                .onChanged { angle = $0 }
                        )
                        .srcLine()
                }
                .padding(24)
            }
            .navigationTitle("CustomActionFail")
        }
    }
}

#Preview {
    AccessibleCustomActionFail()
}
