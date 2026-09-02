import SwiftUI

/// Worst-case version: every visible text label AND every
/// `.accessibilityLabel` has been stripped. Controls are reduced to
/// bare icons or empty-string titles. VoiceOver has nothing to read for
/// most of these — it will announce raw SF Symbol names ("star", "trash",
/// "ellipsis circle"), "Text Field, blank", or nothing meaningful at all.
/// This is deliberately broken — use it only as a "don't ship this" reference.
struct AccessibleNameFail: View {

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

                // MARK: UIKit controls — real UIButton instances, each broken a
                // different way, so the framework's UIKit-only rules have something
                // to fail on (SwiftUI's own Button never triggers these). Placed first
                // so the duplicate-name pair is always captured in a single viewport —
                // Form/List lazily renders rows, so two elements far apart in a long
                // scrollable form are never guaranteed to be laid out simultaneously.
                Section {
                    // No title, no image, no accessibilityLabel — missing accessible name.
                    UIKitButton()
                        .frame(height: 44)
                        .srcLine()
 
                    // Image only, no title, no accessibilityLabel — missing accessible
                    // name for an image button. Uses a plain rendered image because SF
                    // Symbols carry a built-in accessibility label that would give the
                    // button an implicit name.
                    UIKitButton(plainImage: true)
                        .frame(height: 44)
                        .srcLine()

                    // Hint set but no label/title — wrong method used to provide the name.
                    UIKitButton(accessibilityHint: "Deletes this item")
                        .frame(height: 44)
                        .srcLine()
                    // Two buttons sharing the same title (and therefore the same
                    // implicit accessible name) — identical accessible names.
                    UIKitButton(title: "More")
                        .frame(height: 44)
                        .srcLine()
               //         .accessibilityLabel("check")
                    UIKitButton(title: "More")
                        .frame(height: 44)
                        .srcLine()
                    // Looks like a button but cannot be operated — needs a human to
                    // confirm no functionality is attached (BB40001).
                    UIKitButton(title: "Submit application", userInteractionEnabled: false)
                        .frame(height: 44)
                        .srcLine()

                    // Text wired to a tap gesture with no button role: announced as plain
                    // text, so a screen reader user never knows to double-tap it (BB40043).
                    UIKitTappableLabel(text: "Show more details")
                        .frame(height: 44)
                        .srcLine()

                    // Accessible name present, but the .button trait has been stripped.
                    UIKitButton(title: "Archive", clearButtonTrait: true)
                        .frame(height: 44)
                        .srcLine()
                }
                

                // MARK: Button
                Section {
                    Button {
                        // perform action
                    } label: {
                        Image(systemName: "trash")
                    }
                        .srcLine()
                }

                // MARK: Toggle
                Section {
                    Toggle(isOn: $isEnabled) {
                        Image(systemName: "bell")
                    }
                        .srcLine()
                }

                // MARK: Slider
                Section {
                    Slider(value: $volume, in: 0...1) {
                        EmptyView()
                    }
                        .srcLine()
                }

                // MARK: Stepper
                Section {
                    Stepper(value: $quantity, in: 1...10) {
                        EmptyView()
                    }
                        .srcLine()
                }

                // MARK: Picker (segmented)
                Section {
                    Picker("", selection: $selectedColorOption) {
                        ForEach(colorOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                        .srcLine()
                }

                // MARK: Menu
                Section {
                    Menu {
                        Button("", systemImage: "square.and.arrow.up") {}
                        Button("", systemImage: "plus.square.on.square") {}
                        Button("", systemImage: "trash", role: .destructive) {}
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                        .srcLine()
                }

                // MARK: TextField
                Section {
                    TextField("", text: $username)
                        .textContentType(.username)
                        .srcLine()
                }

                // MARK: SecureField
                Section {
                    SecureField("", text: $password)
                        .textContentType(.password)
                        .srcLine()
                }

                // MARK: TextEditor
                Section {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .srcLine()
                }

                // MARK: DatePicker
                Section {
                    DatePicker(
                        "",
                        selection: $birthDate,
                        displayedComponents: .date
                    )
                        .srcLine()
                }

                // MARK: ColorPicker
                Section {
                    // Deliberately unnamed. Collapsed into one element so the row reports
                    // as nameless rather than inheriting the colour well's system-supplied
                    // "Color", which made an unnamed control look as though it had a name.
                    ColorPicker("", selection: $favoriteColor)
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(.isButton)
                        .srcLine()
                }

                // MARK: Link
                Section {
                    Link(destination: URL(string: "https://www.apple.com/accessibility/")!) {
                        Image(systemName: "figure.roll")
                    }
                        .srcLine()
                }

                // MARK: ShareLink
                Section {
                    ShareLink(item: URL(string: "https://developer.apple.com")!) {
                        Image(systemName: "square.and.arrow.up")
                    }
                        .srcLine()
                }

                // MARK: NavigationLink
                Section {
                    NavigationLink {
                        Text("")
                    } label: {
                        Image(systemName: "gearshape")
                    }
                        .srcLine()
                }

                // MARK: Custom tappable icon
                Section {
                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                    }
                        .srcLine()
                }

                // MARK: Custom rating control
                Section {
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .onTapGesture {
                                    rating = star
                                }
                        }
                    }
                }

                // MARK: Checkbox-style toggle
                Section {
                    Toggle(isOn: $agreedToTerms) {
                        Image(systemName: "checkmark")
                    }
                    .toggleStyle(.switch)
                        .srcLine()
                }

                // MARK: Button that triggers a confirmation dialog
                Section {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .confirmationDialog(
                        "",
                        isPresented: $showDeleteConfirmation,
                        titleVisibility: .hidden
                    ) {
                        Button("", role: .destructive) {}
                        Button("", role: .cancel) {}
                    }
                        .srcLine()
                }
            }
        }
    }
}

#Preview {
    AccessibleNameFail()
}
