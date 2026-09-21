import Testing
import SwiftUI
@testable import UIComponents

// MARK: - Emphasis resolution (status → color)

struct DSStatusCardEmphasisTests {

    @Test("Confirmed drives the positive (green) emphasis")
    func confirmedIsPositive() {
        #expect(
            DSStatusCardEmphasis.resolved(explicit: .standard, for: .confirmed) == .positive
        )
    }

    @Test("Cancelled and declined drive the critical (red) emphasis")
    func cancelledAndDeclinedAreCritical() {
        #expect(DSStatusCardEmphasis.resolved(explicit: .standard, for: .declined) == .critical)
        #expect(DSStatusCardEmphasis.resolved(explicit: .standard, for: .cancelled(by: .salon)) == .critical)
        #expect(DSStatusCardEmphasis.resolved(explicit: .standard, for: .cancelled(by: .customer)) == .critical)
    }

    @Test("Requested and finished drive the muted (light) emphasis")
    func requestedAndFinishedAreMuted() {
        #expect(DSStatusCardEmphasis.resolved(explicit: .standard, for: .requested) == .muted)
        #expect(DSStatusCardEmphasis.resolved(explicit: .standard, for: .finished) == .muted)
    }

    @Test("Withdrawn keeps the standard emphasis")
    func withdrawnIsStandard() {
        #expect(DSStatusCardEmphasis.resolved(explicit: .standard, for: .withdrawn) == .standard)
    }

    @Test("A card without a status keeps the standard emphasis")
    func noStatusIsStandard() {
        #expect(DSStatusCardEmphasis.resolved(explicit: .standard, for: nil) == .standard)
    }

    @Test("An explicit emphasis always wins over the status")
    func explicitEmphasisWins() {
        // Confirmed would normally resolve to .positive, but the explicit value wins.
        #expect(DSStatusCardEmphasis.resolved(explicit: .critical, for: .confirmed) == .critical)
        #expect(DSStatusCardEmphasis.resolved(explicit: .muted, for: .cancelled(by: .salon)) == .muted)
    }
}

// MARK: - Palette resolution (variant + emphasis → palette)

struct DSStatusCardPaletteTests {

    @Test("Standard emphasis uses the dark inverse palette when expanded")
    func standardExpandedIsInverse() {
        let palette = DSStatusCardPalette.resolve(.expanded, emphasis: .standard)
        #expect(palette.background == Color.ink)
        #expect(palette.isDark)
    }

    @Test("Standard emphasis uses the light subtle palette when compact")
    func standardCompactIsSubtle() {
        let palette = DSStatusCardPalette.resolve(.compact, emphasis: .standard)
        #expect(palette.background == Color.paper2)
        #expect(!palette.isDark)
    }

    @Test("Positive emphasis is green regardless of variant")
    func positiveIsGreen() {
        #expect(DSStatusCardPalette.resolve(.expanded, emphasis: .positive).background == Color.confirmed)
        #expect(DSStatusCardPalette.resolve(.compact, emphasis: .positive).background == Color.confirmed)
    }

    @Test("Critical emphasis is terracotta regardless of variant")
    func criticalIsTerracotta() {
        #expect(DSStatusCardPalette.resolve(.expanded, emphasis: .critical).background == Color.terracota)
        #expect(DSStatusCardPalette.resolve(.compact, emphasis: .critical).background == Color.terracota)
    }

    @Test("Muted emphasis reuses the light subtle palette")
    func mutedIsSubtle() {
        let muted = DSStatusCardPalette.resolve(.expanded, emphasis: .muted)
        #expect(muted.background == Color.paper2)
        #expect(!muted.isDark)
    }
}
