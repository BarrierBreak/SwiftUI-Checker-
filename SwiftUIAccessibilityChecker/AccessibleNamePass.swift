import SwiftUI

/// Demonstrates every common SwiftUI interactive element paired with an
/// explicit accessible label (and, where useful, a hint/value) so VoiceOver
/// announces something meaningful instead of falling back to a raw title
/// or system default.
struct AccessibleNamePass: View {

    // MARK: - State backing each control

    @State private var isEnabled = false
    @State private var volume: Double = 0.5
    @State private var quantity = 1
    @State private var selectedColorOption = "Blue"
    @State private var favoriteColor = Color.blue
    @State private var username = ""
    @State private var password = ""
    @State private var notes = ""
    @State private var birthDate = Date()
    @State private var agreedToTerms = false
    @State private var showDeleteConfirmation = false
    @State private var rating = 3
    @State private var isFavorite = false

    private let colorOptions = ["Red", "Green", "Blue"]

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Button
                Section("Button") {
                    Button {
                        // perform action
                    } label: {
                        Image(systemName: "trash")
                    }
                        .srcLine()
                    
//                    Button {
//                        
//                    } label: {
//                        Image("zamir")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 200, height: 200)
//                    }
//                    
//                    .buttonStyle(.plain)

                    // Icon-only buttons MUST have a label — otherwise VoiceOver
                    // just reads the SF Symbol's internal name.
                   // .accessibilityLabel("Delete item")
                   // .accessibilityHint("Removes this item from the list")
                }

                // MARK: Toggle
                Section("Toggle") {
                    Toggle(isOn: $isEnabled) {
                      Text("Enable notifications")
                    }
                    .accessibilityLabel("Enable notifications")
                        .srcLine()
                    // Toggle already reads its Text label, but being explicit
                    // protects you if the label view ever becomes an icon.
                }

                // MARK: Slider
                Section("Slider") {
                    Slider(value: $volume, in: 0...1) {
                        Text("Volume")
                    }
                    .accessibilityLabel("Volume")
                    .accessibilityValue("\(Int(volume * 100)) percent")
                        .srcLine()
                }

                // MARK: Stepper
                Section("Stepper") {
                    Stepper(value: $quantity, in: 1...10) {
                        Text("Quantity: \(quantity)")
                    }
                   .accessibilityLabel("Quantity")
                    .accessibilityValue("\(quantity)")
                        .srcLine()
                }

                // MARK: Picker (segmented)
                Section("Segmented Picker") {
                    Picker("Color", selection: $selectedColorOption) {
                        ForEach(colorOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel("Favorite color")
                        .srcLine()
                }

                // MARK: Menu
                Section("Menu") {
                    Menu {
                        Button("Share", systemImage: "square.and.arrow.up") {}
                        Button("Duplicate", systemImage: "plus.square.on.square") {}
                        Button("Delete", systemImage: "trash", role: .destructive) {}
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .accessibilityLabel("More actions")
                        .srcLine()
                }

                // MARK: TextField
                Section("Text Field") {
                    TextField("Username", text: $username)
                        .textContentType(.username)
                        .accessibilityLabel("Username")
                        .accessibilityHint("Enter your account username")
                        .srcLine()
                }

                // MARK: SecureField
                Section("Secure Field") {
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .accessibilityLabel("Password")
                        .accessibilityHint("Enter your account password, minimum 8 characters")
                        .srcLine()
                }

                // MARK: TextEditor
                Section("Text Editor") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .accessibilityLabel("Notes")
                        .accessibilityHint("Enter any additional notes")
                        .srcLine()
                }

                // MARK: DatePicker
                Section("Date Picker") {
                    DatePicker(
                        "Birth date",
                        selection: $birthDate,
                        displayedComponents: .date
                    )
                    .accessibilityLabel("Date of birth")
                        .srcLine()
                }

                // MARK: ColorPicker
                Section("Color Picker") {
                    // ColorPicker builds its own element for the colour well and hard-codes
                    // its label to "Color". A plain .accessibilityLabel is discarded — the
                    // well still reads "Color", so VoiceOver never says which colour this
                    // is for. Collapsing the row into one element replaces that well-owned
                    // element with one the label can apply to; .isButton restores the role
                    // that collapsing removes.
                    ColorPicker("Favorite color", selection: $favoriteColor)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Favorite color")
                        .accessibilityAddTraits(.isButton)
                        .srcLine()
                }

                // MARK: Link
                Section("Link") {
                    Link(destination: URL(string: "https://www.apple.com/accessibility/")!) {
                        Image(systemName: "figure.roll")
                    }
                    .accessibilityLabel("Open Apple Accessibility website")
                        .srcLine()
                }

                // MARK: ShareLink
                Section("Share Link") {
                    ShareLink(item: URL(string: "https://developer.apple.com")!) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel("Share this page")
                        .srcLine()
                }

                // MARK: NavigationLink
                Section("Navigation Link") {
                    NavigationLink {
                        Text("Settings detail screen")
                            .navigationTitle("Settings")
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("Open settings")
                        .srcLine()
                }

                // MARK: Toggle-style favorite icon (custom tap target)
                Section("Custom Tappable Icon") {
                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                    }
                        .srcLine()
                    // Value communicates current state; trait marks it as a button
                    // that can also be selected/toggled, matching Toggle semantics.
                    .accessibilityLabel("Mark as favorite")
                    .accessibilityValue(isFavorite ? "On" : "Off")
                    .accessibilityAddTraits(isFavorite ? [.isButton, .isSelected] : .isButton)
                }

                // MARK: Star rating built from a custom HStack of tappable images
                Section("Custom Rating Control") {
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .onTapGesture {
                                    rating = star
                                }
                                .accessibilityAddTraits(.isButton)
                        }
                    }
                    // Group the row into one element with an adjustable rating
                    // instead of exposing five ambiguous "star" images.
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Rating")
                    .accessibilityValue("\(rating) out of 5 stars")
                    .accessibilityAdjustableAction { direction in
                        switch direction {
                        case .increment: rating = min(rating + 1, 5)
                        case .decrement: rating = max(rating - 1, 1)
                        default: break
                        }
                    }
                }

                // MARK: Toggle for a legal agreement (checkbox-style)
                Section("Checkbox-style Toggle") {
                    Toggle(isOn: $agreedToTerms) {
                        Text("I agree to the Terms of Service")
                    }
                    .toggleStyle(.switch)
                    .accessibilityLabel("Agree to Terms of Service")
                        .srcLine()
                }

                // MARK: Button that triggers a confirmation dialog
                Section("Confirmation Dialog Trigger") {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Text("Delete Account")
                    }
                    .accessibilityLabel("Delete account")
                    .accessibilityHint("Permanently deletes your account. This cannot be undone.")
                    .confirmationDialog(
                        "Delete your account?",
                        isPresented: $showDeleteConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Delete", role: .destructive) {}
                        Button("Cancel", role: .cancel) {}
                    }
                        .srcLine()
                }

                // MARK: UIKit control — real UIButton with a proper accessible name.
                // The framework's UIKit-only rules (button descriptiveness, label-in-name,
                // button trait) never fire on SwiftUI's own Button, which exposes only a
                // UIAccessibilityElement proxy — a real UIButton is needed to exercise them.
                Section("UIKit Control") {
                    UIKitButton(title: "Save Draft")
                        .frame(height: 44)
                        .srcLine()
                }
            }
            .navigationTitle("Accessible Controls")
        }
    }
}

#Preview {
    AccessibleNamePass()
}
