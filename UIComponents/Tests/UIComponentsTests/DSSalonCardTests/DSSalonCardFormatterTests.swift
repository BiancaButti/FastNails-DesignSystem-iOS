import Testing
@testable import UIComponents

struct DSSalonCardFormatterTests {

    // MARK: Price

    @Test("Whole price hides cents")
    func wholePriceHidesCents() {
        let text = DSSalonCardFormatter.priceText(35)
        #expect(text.contains("35"))
        #expect(!text.contains(","))
    }

    @Test("Price with cents shows two digits")
    func priceWithCentsShowsTwoDigits() {
        #expect(DSSalonCardFormatter.priceText(35.5).contains("35,50"))
    }

    // MARK: Spoken price

    @Test("One is spoken in the singular")
    func oneIsSingular() {
        #expect(DSSalonCardFormatter.spokenPrice(1) == "1 real")
    }

    @Test("Other amounts are spoken in the plural")
    func othersArePlural() {
        #expect(DSSalonCardFormatter.spokenPrice(35) == "35 reais")
    }

    // MARK: Distance

    @Test("Nil distance returns nil")
    func nilDistance() {
        #expect(DSSalonCardFormatter.distanceText(meters: nil) == nil)
    }

    @Test("Distance below one kilometer is shown in meters")
    func metersBelowOneKm() {
        #expect(DSSalonCardFormatter.distanceText(meters: 300) == "300 m")
    }

    @Test("Distance at or above one kilometer is shown in kilometers")
    func kilometersAtOrAboveOneKm() {
        #expect(DSSalonCardFormatter.distanceText(meters: 1000) == "1 km")
        #expect(DSSalonCardFormatter.distanceText(meters: 1200) == "1,2 km")
    }

    // MARK: Spoken distance

    @Test("Spoken distance in meters")
    func spokenMeters() {
        #expect(DSSalonCardFormatter.spokenDistance(meters: 300) == "a 300 metros")
    }

    @Test("Spoken distance in kilometers")
    func spokenKilometers() {
        #expect(DSSalonCardFormatter.spokenDistance(meters: 1200) == "a 1,2 quilômetros")
    }

    @Test("Nil distance has no spoken form")
    func spokenNilDistance() {
        #expect(DSSalonCardFormatter.spokenDistance(meters: nil) == nil)
    }

    // MARK: Accessibility label

    @Test("Label follows the fixed product order")
    func labelFollowsFixedOrder() {
        let label = DSSalonCardFormatter.accessibilityLabel(
            name: "Studio Ana",
            price: 35,
            meters: 300,
            availability: "vagas hoje até 19h",
            features: [.semDegrau, .atendimentoEmLibras]
        )

        #expect(
            label == "Studio Ana, 35 reais, a 300 metros, vagas hoje até 19h, Acesso sem degrau, Atendimento em Libras"
        )
    }

    @Test("Label omits distance and availability when absent")
    func labelOmitsOptionalFields() {
        let label = DSSalonCardFormatter.accessibilityLabel(
            name: "Studio Ana",
            price: 1,
            meters: nil,
            availability: nil,
            features: []
        )

        #expect(label == "Studio Ana, 1 real")
    }
}

struct DSSalonAccessibilityFeatureTests {

    @Test("Spoken text falls back to the title")
    func spokenTextFallsBackToTitle() {
        let feature = DSSalonAccessibilityFeature(systemImage: "star", title: "Título")
        #expect(feature.accessibilityText == "Título")
    }

    @Test("Spoken text uses spokenLabel when provided")
    func spokenTextUsesSpokenLabel() {
        let feature = DSSalonAccessibilityFeature(
            systemImage: "star",
            title: "Título",
            spokenLabel: "Falado"
        )
        #expect(feature.accessibilityText == "Falado")
    }

    @Test("Features with different ids are not equal")
    func differentIdsAreNotEqual() {
        #expect(DSSalonAccessibilityFeature.semDegrau != DSSalonAccessibilityFeature.banheiroAdaptado)
    }
}
