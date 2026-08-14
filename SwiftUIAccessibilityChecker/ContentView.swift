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
//  Every row is labelled with the screen's own type name rather than "Pass" /
//  "Fail" / "Partial". Those three words repeated once per section gave four rows
//  reading "Pass" with nothing to tell them apart — the same string a VoiceOver
//  user hears four times, and the same string the scan report names as a screen
//  class. Naming each row after its type matches the UIKit index, where every
//  button already carries a distinct title, and makes a row line up directly with
//  the "Screen Class" it produces in the report and with the per-screen UI test
//  function of the same name.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Accessible Name") {
                    NavigationLink("AccessibleNamePass") { AccessibleNamePass() }
                    NavigationLink("AccessibleNameFail") { AccessibleNameFail() }
                    NavigationLink("AccessibleNamePartial") { AccessibleNamePartial() }
                }

                Section("Accessible Name — Extras") {
                    NavigationLink("AccessibleNameExtrasPass") { AccessibleNameExtrasPass() }
                    NavigationLink("AccessibleNameExtrasFail") { AccessibleNameExtrasFail() }
                    NavigationLink("AccessibleNameExtrasPartial") { AccessibleNameExtrasPartial() }
                }

                Section("Native Role") {
                    NavigationLink("AccessibleNativeRolePass") { AccessibleNativeRolePass() }
                    NavigationLink("AccessibleNativeRoleFail") { AccessibleNativeRoleFail() }
                    NavigationLink("AccessibleNativeRolePartial") { AccessibleNativeRolePartial() }
                }

                Section("Role") {
                    NavigationLink("AccessibleRolePass") { AccessibleRolePass() }
                    NavigationLink("AccessibleRoleFail") { AccessibleRoleFail() }
                    NavigationLink("AccessibleRolePartial") { AccessibleRolePartial() }
                }
            }
            .navigationTitle("Accessibility Examples")
        }
    }
}

#Preview {
    ContentView()
}
