import SwiftUI
import UIKit

/// SwiftUI has no shake modifier. The only way to receive the gesture is a UIKit view that
/// overrides the shake methods, so a SwiftUI screen that acts on shake has one of these in
/// its view hierarchy — which is how the scan finds it.
final class ShakeHandlerView: UIView {

    var onShake: (() -> Void)?

    /// Every handler on screen. A shake goes only to the first responder, so the one that holds
    /// it passes the shake on to the others — each card acts on it.
    private static let handlers = NSHashTable<ShakeHandlerView>.weakObjects()

    override init(frame: CGRect) {
        super.init(frame: frame)
        Self.handlers.add(self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Self.handlers.add(self)
    }

    override var canBecomeFirstResponder: Bool { true }

    /// Takes the first-responder role once on screen, so the shake reaches the handler at all.
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self, self.window != nil, !(self.window?.firstResponder?.isKind(of: ShakeHandlerView.self) ?? false) else { return }
            self.becomeFirstResponder()
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        for handler in Self.handlers.allObjects where handler.window != nil { handler.onShake?() }
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

private extension UIWindow {
    /// The view that currently holds the first-responder role, if any.
    var firstResponder: UIView? {
        func find(_ view: UIView) -> UIView? {
            if view.isFirstResponder { return view }
            for sub in view.subviews { if let found = find(sub) { return found } }
            return nil
        }
        return find(self)
    }
}
