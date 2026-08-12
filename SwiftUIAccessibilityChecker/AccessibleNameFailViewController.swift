import UIKit

/// UIKit equivalent of AccessibleNameFail. Worst case: no accessibilityLabel
/// anywhere, AND no visible text/title/placeholder for VoiceOver to fall
/// back on either. Row title UILabels have been removed entirely. VoiceOver
/// will announce bare control types and raw SF Symbol names — "Button,
/// trash", "Switch, off", "Slider, 50%", "Text Field, blank" — with no way
/// to know what any of it does. Deliberately broken; reference only.
final class AccessibleNameFailViewController: UIViewController {

    // MARK: - Controls

    private let deleteIconButton = UIButton(type: .system)
    private let notificationsSwitch = UISwitch()
    private let volumeSlider = UISlider()
    private let quantityStepper = UIStepper()
    private let colorSegmentedControl = UISegmentedControl(items: ["", "", ""])
    private let moreActionsButton = UIButton(type: .system)
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let notesTextView = UITextView()
    private let birthDatePicker = UIDatePicker()
    private let favoriteColorWell = UIColorWell()
    private let openWebsiteButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let openSettingsButton = UIButton(type: .system)
    private let favoriteStarButton = UIButton(type: .system)
    private let ratingControl = PlainRatingControl(maximumRating: 5)
    private let agreeSwitch = UISwitch()
    private let deleteAccountButton = UIButton(type: .system)

    private var quantity = 1
    private var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        buildLayout()
        // No title, no row labels, no accessibilityLabel calls anywhere.
    }

    // MARK: - Layout

    private func buildLayout() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        deleteIconButton.setImage(UIImage(systemName: "trash"), for: .normal)

        moreActionsButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        moreActionsButton.showsMenuAsPrimaryAction = true
        moreActionsButton.menu = UIMenu(children: [
            UIAction(image: UIImage(systemName: "square.and.arrow.up")) { _ in },
            UIAction(image: UIImage(systemName: "plus.square.on.square")) { _ in },
            UIAction(image: UIImage(systemName: "trash"), attributes: .destructive) { _ in }
        ])

        usernameField.borderStyle = .roundedRect
        // no placeholder

        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        // no placeholder

        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.separator.cgColor
        notesTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        birthDatePicker.datePickerMode = .date
        birthDatePicker.preferredDatePickerStyle = .compact

        openWebsiteButton.setImage(UIImage(systemName: "figure.roll"), for: .normal)
        openWebsiteButton.addAction(UIAction { [weak self] _ in
            guard let url = URL(string: "https://www.apple.com/accessibility/") else { return }
            self?.open(url: url)
        }, for: .touchUpInside)

        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.addAction(UIAction { [weak self] _ in
            guard let url = URL(string: "https://developer.apple.com") else { return }
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self?.present(activityVC, animated: true)
        }, for: .touchUpInside)

        openSettingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        openSettingsButton.addAction(UIAction { [weak self] _ in
            let settingsVC = UIViewController()
            settingsVC.view.backgroundColor = .systemBackground
            self?.navigationController?.pushViewController(settingsVC, animated: true)
        }, for: .touchUpInside)

        favoriteStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteStarButton.addAction(UIAction { [weak self] _ in
            self?.toggleFavorite()
        }, for: .touchUpInside)

        deleteAccountButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteAccountButton.tintColor = .systemRed
        deleteAccountButton.addAction(UIAction { [weak self] _ in
            self?.presentDeleteConfirmation()
        }, for: .touchUpInside)

        quantityStepper.minimumValue = 1
        quantityStepper.maximumValue = 10
        quantityStepper.value = 1
        quantityStepper.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.quantity = Int(self.quantityStepper.value)
        }, for: .valueChanged)

        [
            deleteIconButton,
            notificationsSwitch,
            volumeSlider,
            quantityStepper,
            colorSegmentedControl,
            moreActionsButton,
            usernameField,
            passwordField,
            notesTextView,
            birthDatePicker,
            favoriteColorWell,
            openWebsiteButton,
            shareButton,
            openSettingsButton,
            favoriteStarButton,
            ratingControl,
            agreeSwitch,
            deleteAccountButton
        ].forEach { stack.addArrangedSubview($0) }
    }

    private func open(url: URL) {
        UIApplication.shared.open(url)
    }

    private func toggleFavorite() {
        isFavorite.toggle()
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteStarButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func presentDeleteConfirmation() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "", style: .destructive))
        alert.addAction(UIAlertAction(title: "", style: .cancel))
        present(alert, animated: true)
    }
}
