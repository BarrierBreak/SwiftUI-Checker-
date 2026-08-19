import SwiftUI
import UIKit

/// Worst-case tier for the "extras" categories. Every gap from the Partial
/// file remains, plus the context that even Partial left intact is gone
/// too: the alert has no title/message, the sheet has no navigation title,
/// the popover content is empty, and the destructive alert actions are
/// blank. Deliberately broken; reference only.
struct AccessibleNameExtrasFail: View {

    @State private var showAlert = false
    @State private var showSheet = false
    @State private var showPopover = false
    @State private var progress: Double = 0.4
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                Form {

                    // MARK: Section header — no header, no context at all
                    Section {
                        Text("Wi-Fi, Bluetooth, and other radios")
                    }

                    // MARK: Alert — icon-only trigger, empty title/message
                    Section {
                        Button {
                            showAlert = true
                        } label: {
                            Image(systemName: "airplane")
                        }
                        .alert("", isPresented: $showAlert) {
                            Button("OK") {}
                        }
                            .srcLine()
                        // Blank alert title — VoiceOver announces the alert
                        // opened but gives no indication what it's asking.
                    }

                    // MARK: Sheet — no navigation title, no close label
                    Section {
                        Button {
                            showSheet = true
                        } label: {
                            Image(systemName: "square.on.square")
                        }
                        .sheet(isPresented: $showSheet) {
                            DetailSheetFail()
                        }
                            .srcLine()
                    }

                    // MARK: Popover — icon-only trigger, empty content
                    Section {
                        Button {
                            showPopover = true
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .popover(isPresented: $showPopover) {
                            Color.clear.frame(width: 200, height: 80)
                        }
                            .srcLine()
                    }

                    // MARK: Images — both unhandled
                    Section {
                        HStack {
                            Image(systemName: "sparkles")
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                        }
                        // No adjacent text either — a sighted user relies
                        // entirely on icon shape/color to guess meaning.
                    }

                    // MARK: Progress — no label/value
                    Section {
                        ProgressView(value: progress)
                            .srcLine()
                    }

                    // MARK: Announcement — icon-only, no announcement, no label
                    Section {
                        Button {
                            // no-op, no announcement
                        } label: {
                            Image(systemName: "checkmark")
                        }
                            .srcLine()
                    }
                }
            }
            .tabItem {
                Label("azhar", systemImage: "gearshape")
                    .accessibilityLabel("shaikh")
            }
            .tag(0)

            NavigationStack {
                Text("Second tab content")
            }
            .tabItem {
                Image(systemName: "house")
            }
            .tag(1)
        }
    }
}

/// No `.isModal` trait, no navigation title, no close-button label.
private struct DetailSheetFail: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Modal sheet content goes here.")
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
        }
    }
}

#Preview {
    AccessibleNameExtrasFail()
}
