import SwiftUI
import UIKit

/// SwiftUI has no shake modifier. The only way to receive the gesture is a UIKit view that
/// overrides the shake methods, so a SwiftUI screen that acts on shake has one of these in
/// its view hierarchy — which is how the scan finds it.
final class ShakeHandlerView: UIView {

    var onShake: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        onShake?()
    }
}

struct ShakeHandler: UIViewRepresentable {

    let onShake: () -> Void

    func makeUIView(context: Context) -> ShakeHandlerView {
        let view = ShakeHandlerView()
        view.onShake = onShake
        return view
    }

    func updateUIView(_ uiView: ShakeHandlerView, context: Context) {
        uiView.onShake = onShake
    }
}

extension View {
    /// Acts on a shake. The handler sits behind this view and takes its frame, so the scan
    /// can tell which controls belong to the action.
    func onShake(perform action: @escaping () -> Void) -> some View {
        background(ShakeHandler(onShake: action))
    }
}
