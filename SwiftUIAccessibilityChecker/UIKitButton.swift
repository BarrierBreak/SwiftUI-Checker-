//
//  UIKitButton.swift
//  SwiftUIAccessibilityChecker
//
//  Wraps a real UIButton so the framework's UIKit-only workflows
//  (UIButtonAccessibilityWorkflow, LabelInNameWorkflow's duplicate-name check,
//  AccessibilityTraitsWorkflow's button-trait check) have literal UIButton
//  instances to evaluate. SwiftUI's own Button exposes only a
//  UIAccessibilityElement proxy — never a real UIButton — so those rules can
//  never fire on pure-SwiftUI content.
//

import SwiftUI
import UIKit

struct UIKitButton: UIViewRepresentable {
    var title: String? = nil
    var systemImage: String? = nil
    /// A rendered image with no accessibility metadata — unlike SF Symbols, which
    /// carry a built-in accessibility label ("Bin" for trash, …) that gives the
    /// button an implicit name. Use this to demonstrate a genuinely nameless
    /// image button.
    var plainImage: Bool = false
    var accessibilityLabel: String? = nil
    var accessibilityHint: String? = nil
    var clearButtonTrait: Bool = false
    /// Renders a button that cannot be operated. If interaction genuinely is not wanted,
    /// the element should not look or behave like a button — so this needs a human to
    /// confirm there really is no functionality behind it (BB40001).
    var userInteractionEnabled: Bool = true

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.isAccessibilityElement = true
        if let title { button.setTitle(title, for: .normal) }
        if let systemImage { button.setImage(UIImage(systemName: systemImage), for: .normal) }
        if plainImage {
            let image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 24)).image { ctx in
                UIColor.systemBlue.setFill()
                ctx.fill(CGRect(x: 0, y: 0, width: 24, height: 24))
            }
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        if let accessibilityLabel { button.accessibilityLabel = accessibilityLabel }
        if let accessibilityHint { button.accessibilityHint = accessibilityHint }
        if clearButtonTrait { button.accessibilityTraits = [] }
        button.isUserInteractionEnabled = userInteractionEnabled
        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {}
}


/// Wraps a real UILabel wired to a tap gesture — text that behaves as a button but never
/// announces the role, so a screen reader user is told it is plain text and has no reason
/// to double-tap it (BB40043).
///
/// This has to be a UIKit view: SwiftUI's `.onTapGesture` leaves no trace in the
/// accessibility tree, so tappable Text and plain Text are indistinguishable at runtime.
/// UIKit exposes the gesture recogniser, which is what the rule keys on.
struct UIKitTappableLabel: UIViewRepresentable {
    var text: String
    /// Set to add the button trait, which is the correct authoring — used by the Pass
    /// screen so the same construct can demonstrate both the defect and the fix.
    var announcesButtonRole: Bool = false

    final class Coordinator {
        @objc func handleTap() {
            // Stand-in for whatever action the text performs.
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .systemBlue
        label.isUserInteractionEnabled = true
        label.isAccessibilityElement = true
        if announcesButtonRole {
            label.accessibilityTraits.insert(.button)
        } else {
            // Inside a SwiftUI hierarchy the platform adds .button to a label that has a
            // tap gesture, so the element announces the role by itself and there is no
            // defect to find — measured traits were 65 (.staticText + .button). Removing
            // it reproduces what the source-level rule calls `removesButtonTrait`: the
            // developer has taken the role away, leaving text that acts as a button but
            // announces as plain text.
            label.accessibilityTraits = .staticText
        }
        label.addGestureRecognizer(
            UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        )
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {}
}
