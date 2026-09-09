import SwiftUI

/// TARGET SIZE — Partial tier.
///
/// The borderline cases, which is where this rule is actually decided. Every control here
/// sits close enough to the 24pt line that looking at the screen tells you nothing — and
/// crucially, two of them are crowded and still pass, because size is checked FIRST:
///
///   • at least 24×24pt → passes, and the spacing around it is never measured. The spacing
///     exception exists to rescue undersized targets, so a 44pt button 8pt from its
///     neighbour meets 2.5.8 and reporting the gap would be reporting something the
///     criterion does not ask for.
///   • under 24×24pt → the exception is the only way through, and it needs 24pt of clear
///     space on every side that has a neighbour.
///
/// Half of this screen passes and half fails, and the difference is measurable rather than
/// visible. That is the argument for measuring rather than eyeballing.
///
/// Element-by-element:
///   1. Padded to ~36pt, crowded 6pt  — PASSES: big enough, so spacing is not measured
///   2. 44×44, crowded by 8pt         — PASSES: comfortably sized, gap irrelevant
///   3. 22×22 with 24pt clear space   — PASSES: undersized, rescued by the exception
///   4. 22×22 with 10pt clear space   — FAILS: undersized and well short of the exception
///   5. 23×23, isolated               — PASSES: 1pt under the line, nothing near it
struct AccessibleTargetSizePartial: View {

    @State private var lastTapped = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 48) {

                    // MARK: 1 — genuinely big enough, and crowded
                    //
                    // Padding plus `contentShape`, not `.frame(width:height:)`. That
                    // distinction is the lesson: `.frame` sets the LAYOUT size, while the
                    // frame the accessibility tree reports follows the content — so an SF
                    // Symbol inside a `.frame(width: 28, height: 28)` button still measures
                    // around 20pt and lands in the undersized branch. Padding grows the
                    // content itself, and `contentShape` makes the grown area the hit region,
                    // so the measured target really is 24pt or more.
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Padded to ~36pt, only 6pt from its neighbour").font(.headline)
                        HStack(spacing: 6) {
                            Button { lastTapped = "Filter" } label: {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .padding(10)
                                    .contentShape(Rectangle())
                            }
                            .accessibilityLabel("Filter results")
                            .srcLine()

                            Button { lastTapped = "Sort" } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .padding(10)
                                    .contentShape(Rectangle())
                            }
                            .accessibilityLabel("Sort results")
                            .srcLine()
                        }
                    }

                    // MARK: 2 — comfortably sized, and crowded
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Two 44×44 buttons, 8pt apart").font(.headline)
                        HStack(spacing: 8) {
                            Button("Save") { lastTapped = "Save" }
                                .frame(width: 60, height: 44)
                                .srcLine()

                            Button("Discard") { lastTapped = "Discard" }
                                .frame(width: 72, height: 44)
                                .srcLine()
                        }
                    }

                    // MARK: 3 — undersized, rescued by clear space
                    VStack(alignment: .leading, spacing: 8) {
                        Text("22×22 with 24pt of clear space").font(.headline)
                        HStack(spacing: 24) {
                            Button { lastTapped = "Edit" } label: {
                                Image(systemName: "pencil")
                            }
                            .frame(width: 22, height: 22)
                            .accessibilityLabel("Edit note")
                            .srcLine()

                            Button("Done") { lastTapped = "Done" }
                                .frame(width: 60, height: 44)
                                .srcLine()
                        }
                    }

                    // MARK: 4 — undersized and well short of the exception
                    VStack(alignment: .leading, spacing: 8) {
                        Text("22×22 with only 10pt of clear space").font(.headline)
                        HStack(spacing: 10) {
                            Button { lastTapped = "Delete" } label: {
                                Image(systemName: "trash")
                            }
                            .frame(width: 22, height: 22)
                            .accessibilityLabel("Delete note")
                            .srcLine()

                            Button("Cancel") { lastTapped = "Cancel" }
                                .frame(width: 72, height: 44)
                                .srcLine()
                        }
                    }

                    // MARK: 5 — a hair under the line, but nothing is near it
                    VStack(alignment: .leading, spacing: 8) {
                        Text("23×23, on its own").font(.headline)
                        Button { lastTapped = "Refresh" } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .frame(width: 23, height: 23)
                        .accessibilityLabel("Refresh")
                        .srcLine()
                    }
                }
                .padding(24)
            }
            .navigationTitle("Target Size (Partial)")
        }
    }
}

#Preview {
    AccessibleTargetSizePartial()
}
