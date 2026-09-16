import Foundation
import Testing
@testable import UIComponents

struct DSLinkNoteAttributedTests {

    /// Flattens the runs of an AttributedString into `(text, hasLink)` pairs,
    /// so tests can assert on plain text and which segments became links.
    private func segments(_ attributed: AttributedString) -> [(text: String, hasLink: Bool)] {
        attributed.runs.map { run in
            (String(attributed[run.range].characters), run.link != nil)
        }
    }

    @Test("Sequential placeholders map to links in order")
    func sequentialPlaceholders() {
        let terms = DSLink("Terms") { }
        let privacy = DSLink("Privacy") { }

        let result = DSLinkNote.attributed(
            format: "Read the %@ and the %@.",
            links: [terms, privacy]
        )

        #expect(String(result.characters) == "Read the Terms and the Privacy.")
    }

    @Test("Explicit indices reorder the links regardless of position")
    func explicitIndicesReorder() {
        let terms = DSLink("Terms") { }
        let privacy = DSLink("Privacy") { }

        // %2$@ comes first, so it must resolve to the second link (Privacy).
        let result = DSLinkNote.attributed(
            format: "First %2$@ then %1$@.",
            links: [terms, privacy]
        )

        #expect(String(result.characters) == "First Privacy then Terms.")
    }

    @Test("Escaped %% renders as a single literal percent, not a link")
    func escapedPercentIsLiteral() {
        let link = DSLink("here") { }

        let result = DSLinkNote.attributed(
            format: "100%% off, tap %@.",
            links: [link]
        )

        #expect(String(result.characters) == "100% off, tap here.")

        // Only "here" should carry a link; the literal percent must not.
        let linked = segments(result).filter(\.hasLink).map(\.text)
        #expect(linked == ["here"])
    }

    @Test("Placeholder without a matching link falls back to the raw token")
    func missingLinkFallsBackToRawToken() {
        let result = DSLinkNote.attributed(
            format: "Agree to %@ and %@.",
            links: [DSLink("Terms") { }]
        )

        #expect(String(result.characters) == "Agree to Terms and %@.")
    }
}
