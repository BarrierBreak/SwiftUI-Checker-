//
//  ContentView.swift
//  SwiftUIAccessibilityChecker
//
//  Created by Azharuddin   on 30/07/26.
//
//  Navigation index for every example screen. The scan runner drives these same
//  screens headlessly via --a11y-scan (see SwiftUIA11yScanRunner); this list is
//  for opening them by hand to inspect with VoiceOver or the Accessibility
//  Inspector. Screens are grouped by ruleset, each with its Pass / Fail / Partial
//  variant.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Accessible Name") {
                    NavigationLink("Pass") { AccessibleNamePass() }
                    NavigationLink("Fail") { AccessibleNameFail() }
                    NavigationLink("Partial") { AccessibleNamePartial() }
                }

                Section("Native Role") {
                    NavigationLink("Pass") { AccessibleNativeRolePass() }
                    NavigationLink("Fail") { AccessibleNativeRoleFail() }
                    NavigationLink("Partial") { AccessibleNativeRolePartial() }
                }

                Section("Role") {
                    NavigationLink("Pass") { AccessibleRolePass() }
                    NavigationLink("Fail") { AccessibleRoleFail() }
                    NavigationLink("Partial") { AccessibleRolePartial() }
                }
            }
            .navigationTitle("Accessibility Examples")
        }
    }
}

#Preview {
    ContentView()
}
