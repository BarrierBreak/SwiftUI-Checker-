import SwiftUI

/// Same controls as AccessibleNamePass, but with every
/// `.accessibilityLabel` removed. Useful as a "before" comparison —
/// several of these controls (icon-only Button, Menu, Link, ShareLink,
/// NavigationLink, the custom star icon, the custom rating row) will now
/// read poorly or ambiguously to VoiceOver since they have no text label
/// to fall back on.
struct AccessibleNamePartial: View {

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
                }

                // MARK: Toggle
                Section("Toggle") {
                    Toggle(isOn: $isEnabled) {
                        Text("Enable notifications")
                    }
                        .srcLine()
                }

                // MARK: Slider
                Section("Slider") {
                    Slider(value: $volume, in: 0...1) {
                        Text("Volume")
                    }
                        .srcLine()
                }

                // MARK: Stepper
                Section("Stepper") {
                    Stepper(value: $quantity, in: 1...10) {
                        Text("Quantity: \(quantity)")
                    }
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
                        .srcLine()
                }

                // MARK: TextField
                Section("Text Field") {
                    TextField("Username", text: $username)
                        .textContentType(.username)
                        .srcLine()
                }

                // MARK: SecureField
                Section("Secure Field") {
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .srcLine()
                }

                // MARK: TextEditor
                Section("Text Editor") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .srcLine()
                }

                // MARK: DatePicker
                Section("Date Picker") {
                    DatePicker(
                        "Birth date",
                        selection: $birthDate,
                        displayedComponents: .date
                    )
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
                        .srcLine()
                }

                // MARK: ShareLink
                Section("Share Link") {
                    ShareLink(item: URL(string: "https://developer.apple.com")!) {
                        Image(systemName: "square.and.arrow.up")
                    }
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
                }

                // MARK: Star rating built from a custom HStack of tappable images
                Section("Custom Rating Control") {
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .onTapGesture {
                                    rating = star
                                }
                        }
                    }
                }

                // MARK: Toggle for a legal agreement (checkbox-style)
                Section("Checkbox-style Toggle") {
                    Toggle(isOn: $agreedToTerms) {
                        Text("I agree to the Terms of Service")
                    }
                    .toggleStyle(.switch)
                        .srcLine()
                }

                // MARK: Button that triggers a confirmation dialog
                Section("Confirmation Dialog Trigger") {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Text("Delete Account")
                    }
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
            }
            .navigationTitle("Plain Controls")
        }
    }
}

#Preview {
    AccessibleNamePartial()
}
