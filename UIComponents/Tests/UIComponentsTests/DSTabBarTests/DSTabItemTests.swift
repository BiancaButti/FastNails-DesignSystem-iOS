import SwiftUI
import Testing
@testable import UIComponents

/// A fixture tab used to exercise the ``DSTabItem`` default implementations.
private enum FixtureTab: DSTabItem {
    case home, bookings, profile

    var title: LocalizedStringKey {
        switch self {
        case .home: "Home"
        case .bookings: "Bookings"
        case .profile: "Profile"
        }
    }

    var icon: Image {
        switch self {
        case .home: Image(systemName: "house")
        case .bookings: Image(systemName: "calendar")
        case .profile: Image(systemName: "person")
        }
    }
}

struct DSTabItemTests {

    @Test("Default id is the case itself")
    func idIsSelf() {
        for tab in FixtureTab.allCases {
            #expect(tab.id == tab)
        }
    }

    @Test("Distinct cases have distinct ids")
    func idsAreDistinct() {
        let ids = Set(FixtureTab.allCases.map(\.id))
        #expect(ids.count == FixtureTab.allCases.count)
    }

    @Test("allCases preserves declaration order")
    func allCasesOrder() {
        #expect(Array(FixtureTab.allCases) == [.home, .bookings, .profile])
    }
}
