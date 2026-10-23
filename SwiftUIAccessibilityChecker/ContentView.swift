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

                Section("State") {
                    NavigationLink("AccessibleStatePass") { AccessibleStatePass() }
                    NavigationLink("AccessibleStateFail") { AccessibleStateFail() }
                    NavigationLink("AccessibleStatePartial") { AccessibleStatePartial() }
                }

                Section("Keyboard") {
                    NavigationLink("AccessibleKeyboardPass") { AccessibleKeyboardPass() }
                    NavigationLink("AccessibleKeyboardFail") { AccessibleKeyboardFail() }
                    NavigationLink("AccessibleKeyboardPartial") { AccessibleKeyboardPartial() }
                }

                Section("Target Size") {
                    NavigationLink("AccessibleTextResizePass") { AccessibleTextResizePass() }
                    NavigationLink("AccessibleTextResizeFail") { AccessibleTextResizeFail() }
                    NavigationLink("AccessibleTextResizePartial") { AccessibleTextResizePartial() }
                    NavigationLink("AccessibleTextClippingPass") { AccessibleTextClippingPass() }
                    NavigationLink("AccessibleTextClippingFail") { AccessibleTextClippingFail() }
                    NavigationLink("AccessibleTextClippingPartial") { AccessibleTextClippingPartial() }
                    NavigationLink("AccessibleTargetSizePass") { AccessibleTargetSizePass() }
                    NavigationLink("AccessibleTargetSizeFail") { AccessibleTargetSizeFail() }
                    NavigationLink("AccessibleTargetSizePartial") { AccessibleTargetSizePartial() }
                    NavigationLink("AccessibleHiddenPass") { AccessibleHiddenPass() }
                    NavigationLink("AccessibleHiddenFail") { AccessibleHiddenFail() }
                    NavigationLink("AccessibleHiddenPartial") { AccessibleHiddenPartial() }
                    NavigationLink("AccessibleLanguagePass") { AccessibleLanguagePass() }
                    NavigationLink("AccessibleLanguageFail") { AccessibleLanguageFail() }
                    NavigationLink("AccessibleLanguagePartial") { AccessibleLanguagePartial() }
                    NavigationLink("AccessibleMotionPass") { AccessibleMotionPass() }
                    NavigationLink("AccessibleMotionFail") { AccessibleMotionFail() }
                    NavigationLink("AccessibleMotionPartial") { AccessibleMotionPartial() }
                    NavigationLink("AccessibleImagesPass") { AccessibleImagesPass() }
                    NavigationLink("AccessibleImagesFail") { AccessibleImagesFail() }
                    NavigationLink("AccessibleImagesPartial") { AccessibleImagesPartial() }
                    NavigationLink("AccessibleReadingOrderPass") { AccessibleReadingOrderPass() }
                    NavigationLink("AccessibleReadingOrderFail") { AccessibleReadingOrderFail() }
                    NavigationLink("AccessibleReadingOrderPartial") { AccessibleReadingOrderPartial() }
                    NavigationLink("AccessibleFocusPass") { AccessibleFocusPass() }
                    NavigationLink("AccessibleFocusFail") { AccessibleFocusFail() }
                    NavigationLink("AccessibleFocusPartial") { AccessibleFocusPartial() }
                    NavigationLink("AccessibleLinkPass") { AccessibleLinkPass() }
                    NavigationLink("AccessibleLinkFail") { AccessibleLinkFail() }
                    NavigationLink("AccessibleLinkPartial") { AccessibleLinkPartial() }
                    NavigationLink("AccessibleRoleTraitPass") { AccessibleRoleTraitPass() }
                    NavigationLink("AccessibleRoleTraitFail") { AccessibleRoleTraitFail() }
                    NavigationLink("AccessibleRoleTraitPartial") { AccessibleRoleTraitPartial() }
                    NavigationLink("AccessibleStateTraitPass") { AccessibleStateTraitPass() }
                    NavigationLink("AccessibleStateTraitFail") { AccessibleStateTraitFail() }
                    NavigationLink("AccessibleStateTraitPartial") { AccessibleStateTraitPartial() }
                    NavigationLink("AccessibleButtonPass") { AccessibleButtonPass() }
                    NavigationLink("AccessibleButtonFail") { AccessibleButtonFail() }
                    NavigationLink("AccessibleButtonPartial") { AccessibleButtonPartial() }
                    NavigationLink("AccessibleFormLabelPass") { AccessibleFormLabelPass() }
                    NavigationLink("AccessibleFormLabelFail") { AccessibleFormLabelFail() }
                    NavigationLink("AccessibleFormLabelPartial") { AccessibleFormLabelPartial() }
                    NavigationLink("AccessibleCustomActionPass") { AccessibleCustomActionPass() }
                    NavigationLink("AccessibleCustomActionFail") { AccessibleCustomActionFail() }
                    NavigationLink("AccessibleCustomActionPartial") { AccessibleCustomActionPartial() }
                    NavigationLink("AccessibleTouchEventPass") { AccessibleTouchEventPass() }
                    NavigationLink("AccessibleTouchEventFail") { AccessibleTouchEventFail() }
                    NavigationLink("AccessibleTouchEventPartial") { AccessibleTouchEventPartial() }
                }

                Section("Text Contrast") {
                    NavigationLink("AccessibleTextContrastPass") { AccessibleTextContrastPass() }
                    NavigationLink("AccessibleTextContrastFail") { AccessibleTextContrastFail() }
                    NavigationLink("AccessibleTextContrastPartial") { AccessibleTextContrastPartial() }
                }

                Section("Composited Contrast") {
                    NavigationLink("AccessibleTextContrastCompositedPass") { AccessibleTextContrastCompositedPass() }
                    NavigationLink("AccessibleTextContrastCompositedFail") { AccessibleTextContrastCompositedFail() }
                    NavigationLink("AccessibleTextContrastCompositedPartial") { AccessibleTextContrastCompositedPartial() }
                }
            }
            .navigationTitle("Accessibility Examples")
        }
    }
}

#Preview {
    ContentView()
}
