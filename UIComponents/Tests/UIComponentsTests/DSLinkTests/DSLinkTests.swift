import Foundation
import Testing
@testable import UIComponents

struct DSLinkTests {

    @Test("URL initializer stores the title and a url destination")
    func urlInitializerStoresTitleAndDestination() throws {
        let url = try #require(URL(string: "https://fastnails.app"))

        let link = DSLink("Termos de uso", url: url)

        #expect(link.title == "Termos de uso")

        guard case let .url(storedURL) = link.destination else {
            Issue.record("Expected a .url destination")
            return
        }
        #expect(storedURL == url)
    }

    @Test("Action initializer stores the title and an action destination")
    func actionInitializerStoresTitleAndDestination() {
        let link = DSLink("Esqueci minha senha") { }

        #expect(link.title == "Esqueci minha senha")

        guard case .action = link.destination else {
            Issue.record("Expected an .action destination")
            return
        }
    }

    @Test("Action destination executes the provided block when invoked")
    func actionDestinationExecutesBlock() {
        var didExecute = false

        let link = DSLink("Esqueci minha senha") {
            didExecute = true
        }

        guard case let .action(action) = link.destination else {
            Issue.record("Expected an .action destination")
            return
        }
        action()

        #expect(didExecute)
    }
}
