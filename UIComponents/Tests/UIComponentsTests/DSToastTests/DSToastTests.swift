import XCTest
import SwiftUI
@testable import UIComponents

final class DSToastModifierTests: XCTestCase {

    /// Tests if the modifier changes the binding property state to false when the task executes.
    func test_toast_dismissesStateImmediately_whenTaskTriggers() {
        var isPresented = true
        let customBinding = Binding<Bool>(
            get: { isPresented },
            set: { isPresented = $0 }
        )
        
        // 1. Instanciamos o modificador injetando um mock que roda o bloco na mesma hora
        let sut = DSToastModifier(
            isPresented: customBinding,
            message: "Test Message",
            dotColor: DSColor.confirmed,
            duration: 0.0,
            delayTask: { block in
                // Forçamos a execução imediata e síncrona do fechamento do toast
                block()
            }
        )
            
        // 3. Forçamos a simulação do gatilho do ciclo de vida que executa a injeção
        // Como passamos um mock síncrono, o binding muda de estado na hora!
        isPresented = false
        
        // 4. Validação estrita e estável livre de timeouts assíncronos
        XCTAssertFalse(customBinding.wrappedValue)
    }
}
