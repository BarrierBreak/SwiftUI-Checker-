import SwiftUI
import UIKit

/// Partial tier for the "extras" categories (dialogs, sheets, popovers,
/// headers, images, progress, announcements, tab items). No explicit
/// accessibility wiring is added on top of what SwiftUI gives by default.
/// Text-bearing elements (alert titles, named buttons) still read fine —
/// SwiftUI's Text/Button always expose their string automatically. The
/// gaps appear on icon-only controls and on semantics that require an
/// explicit trait/value/notification rather than visible text:
/// the header isn't announced as a heading, the close/info icon buttons
/// read their SF Symbol name, the decorative image is announced as noise,
/// the informative image reads its symbol name instead of "Warning", the
/// progress bar has no context, the save action never announces, and the
/// tab item reads "gearshape" instead of "Settings".
struct AccessibleNameExtrasPartial: View {

    @State private var showAlert = false
    @State private var showSheet = false
    @State private var showPopover = false
    @State private var progress: Double = 0.4
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                Form {

                    // MARK: Section header — no .isHeader trait
                    Section {
                        Text("Wi-Fi, Bluetooth, and other radios")
                    } header: {
                        Text("Connectivity")
                        // Visually looks like a header, but VoiceOver's
                        // rotor won't recognize it as one — it reads as
                        // plain body text in the linear swipe order.
                    }

                    // MARK: Alert / dialog box
                    Section("Alert") {
                        Button("Show Alert") { showAlert = true }
                            .alert("Turn on Airplane Mode?", isPresented: $showAlert) {
                                Button("Cancel", role: .cancel) {}
                                Button("Turn On") {}
                            } message: {
                                Text("This will disable Wi-Fi and Cellular Data.")
                            }
                            .srcLine()
                        // Alert itself is fine — title/message/buttons are
                        // all real text, which SwiftUI exposes by default.
                    }

                    // MARK: Sheet / modal
                    Section("Sheet") {
                        Button("Show Sheet") { showSheet = true }
                            .sheet(isPresented: $showSheet) {
                                DetailSheetPartial()
                            }
                            .srcLine()
                    }

                    // MARK: Popover — icon-only trigger, no label
                    Section("Popover") {
                        Button {
                            showPopover = true
                        } label: {
                            Image(systemName: "info.circle")
                        }
                            .srcLine()
                        // No .accessibilityLabel — VoiceOver reads
                        // "info circle, button" instead of "More information".
                        .popover(isPresented: $showPopover) {
                            Text("This feature syncs your data across devices.")
                                .padding()
                        }
                    }

                    // MARK: Decorative vs. informative image — neither handled
                    Section("Images") {
                        HStack {
                            // Not hidden — VoiceOver announces "sparkles",
                            // pure noise with no semantic value.
                            Image(systemName: "sparkles")

                            // No .accessibilityLabel — VoiceOver reads
                            // "exclamationmark triangle fill" instead of "Warning".
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)

                            Text("Battery is low")
                        }
                    }

                    // MARK: Determinate progress — no label/value context
                    Section("Progress") {
                        ProgressView(value: progress)
                            .srcLine()
                        // Reads "40%" with no indication of what's progressing.
                    }

                    // MARK: Announcement — button exists but never posts one
                    Section("Announcement") {
                        Button("Save Changes") {
                            // No UIAccessibility.post call — VoiceOver users
                            // get zero confirmation the save happened.
                        }
                            .srcLine()
                    }
                }
                .navigationTitle("Extras")
            }
            .tabItem {
                Image(systemName: "gearshape")
            }
            // No .accessibilityLabel — reads "gearshape, tab 1 of 2".
            .tag(0)

            NavigationStack {
                Text("Second tab content")
                    .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "house")
            }
            .tag(1)
        }
    }
}

/// No `.isModal` trait — VoiceOver's swipe navigation can leak out of this
/// sheet back into the presenting view underneath.
private struct DetailSheetPartial: View {
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
                    // No .accessibilityLabel — reads "xmark, button".
                }
            }
        }
    }
}

#Preview {
    AccessibleNameExtrasPartial()
}

