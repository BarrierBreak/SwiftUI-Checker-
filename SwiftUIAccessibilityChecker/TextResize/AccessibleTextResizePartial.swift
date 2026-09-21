import SwiftUI

/// TEXT RESIZE — Partial tier. WCAG 1.4.4.
///
/// The half-migrated screen, which is what most real codebases look like: the body copy was
/// moved onto Dynamic Type and the small chrome around it was not. The scan should report
/// both "Text can be resized" (BB40032) and "Text fails to resize" (BB40031) on the same
/// screen, which is what separates this tier from Pass and Fail.
///
/// Three scale, two do not. Both failures are small text — the pattern worth noticing, since
/// fixed sizes survive longest exactly where the text is already hardest to read.
struct AccessibleTextResizePartial: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your orders")
                    .font(.title)
                    .srcLine()

                Text("Track a delivery or start a return.")
                    .font(.body)
                    .srcLine()

                Text("Returns are free within 30 days.")
                    .font(.footnote)
                    .srcLine()

                // Not migrated.
                Text("2 items")
                    .font(.system(size: 11))
                    .srcLine()

                Text("Orders")
                    .font(.system(size: 10))
                    .srcLine()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Text Resize (Partial)")
    }
}
