import SwiftUI
import UIKit // for UIAccessibility.post announcements

/// Fourth companion file: covers the accessibility categories that AREN'T
/// plain form controls — alert dialogs, sheets/modals, popovers, section
/// headers, decorative vs. informative images, a determinate progress
/// value, a live announcement (toast), and icon-only tab bar items.
struct AccessibleNameExtrasPass: View {

    @State private var showAlert = false
    @State private var showSheet = false
    @State private var showPopover = false
    @State private var progress: Double = 0.4
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                Form {

                    // MARK: Section header
                    Section {
                        Text("Wi-Fi, Bluetooth, and other radios")
                    } header: {
                        Text("Connectivity")
                            // Marks this as a heading so VoiceOver users can
                            // jump between sections with the rotor instead of
                            // reading everything linearly.
                            .accessibilityAddTraits(.isHeader)
                    }

                    // MARK: Alert / dialog box
                    Section("Alert") {
                        Button("Show Alert") { showAlert = true }
                            .accessibilityHint("Opens a dialog to confirm turning on Airplane Mode")
                            .alert("Turn on Airplane Mode?", isPresented: $showAlert) {
                                Button("Cancel", role: .cancel) {}
                                Button("Turn On") {}
                            } message: {
                                Text("This will disable Wi-Fi and Cellular Data.")
                            }
                            .srcLine()
                        // The alert's title/message are read automatically;
                        // both action buttons have real titles, not icons.
                    }

                    // MARK: Sheet / modal
                    Section("Sheet") {
                        Button("Show Sheet") { showSheet = true }
                            .sheet(isPresented: $showSheet) {
                                DetailSheetPass()
                            }
                            .srcLine()
                    }

                    // MARK: Popover
                    Section("Popover") {
                        Button {
                            showPopover = true
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .accessibilityLabel("More information")
                        .popover(isPresented: $showPopover) {
                            Text("This feature syncs your data across devices.")
                                .padding()
                                .accessibilityLabel("Sync explanation: this feature syncs your data across devices")
                        }
                            .srcLine()
                    }

                    // MARK: Decorative vs. informative image
                    Section("Images") {
                        HStack {
                            // Purely decorative — hidden so VoiceOver skips it
                            // entirely instead of announcing "sparkles".
                            Image(systemName: "sparkles")
                                .accessibilityHidden(true)

                            // Informative — conveys a warning state, so it
                            // needs its own label even though there's also
                            // adjacent text.
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                                .accessibilityLabel("Warning")

                            Text("Battery is low")
                        }
                    }

                    // MARK: Determinate progress indicator
                    Section("Progress") {
                        ProgressView(value: progress)
                            .accessibilityLabel("Download progress")
                            .accessibilityValue("\(Int(progress * 100)) percent")
                            .srcLine()
                    }

                    // MARK: Live announcement (toast-style feedback)
                    Section("Announcement") {
                        Button("Save Changes") {
                            // Nothing visually moves focus here, so a toast/
                            // banner needs an explicit announcement or
                            // VoiceOver users never learn it happened.
                            UIAccessibility.post(
                                notification: .announcement,
                                argument: "Changes saved"
                            )
                        }
                            .srcLine()
                    }
                }
                .navigationTitle("Extras")
            }
            .tabItem {
                Image(systemName: "gearshape")
            }
            // Icon-only tab item — without this, VoiceOver reads "gearshape,
            // tab 1 of 2" instead of a meaningful name.
            .accessibilityLabel("Settings")
            .tag(0)

            NavigationStack {
                Text("Second tab content")
                    .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "house")
            }
            .accessibilityLabel("Home")
            .tag(1)
        }
    }
}

/// Presented modally. Marked `.isModal` so VoiceOver traps swipe navigation
/// inside the sheet instead of letting it "leak" to the view underneath.
private struct DetailSheetPass: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Modal sheet content goes here.")
            }
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Close")
                }
            }
        }
        .accessibilityAddTraits(.isModal)
    }
}

#Preview {
    AccessibleNameExtrasPass()
}

