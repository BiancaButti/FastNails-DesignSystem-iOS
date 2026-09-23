import XCTest
import SwiftUI
@testable import UIComponents

final class DSSegmentedControlTests: XCTestCase {
    
    private enum DummyOptions: String, CaseIterable {
        case first = "Próximos"
        case second = "Anteriores"
    }

    func test_init_retainsCorrectInitialSelection() {
        let binding = Binding<DummyOptions>.constant(.first)
        let sut = DSSegmentedControl(selection: binding, options: DummyOptions.allCases, titleKeyPath: \.rawValue)
        XCTAssertNotNil(sut)
    }
    
    func test_selectionChange_updatesBindingState() {
        var localSelection: DummyOptions = .first
        let customBinding = Binding<DummyOptions>(
            get: { localSelection },
            set: { localSelection = $0 }
        )
        
        let options = DummyOptions.allCases
        let _ = DSSegmentedControl(selection: customBinding, options: options, titleKeyPath: \.rawValue)
        
        customBinding.wrappedValue = .second
        
        XCTAssertEqual(localSelection, .second)
    }
}
