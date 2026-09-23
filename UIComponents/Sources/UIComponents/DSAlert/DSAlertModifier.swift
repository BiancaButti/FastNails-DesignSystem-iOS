import SwiftUI

// MARK: - ViewModifier Extension

struct DSAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let alert: () -> DSAlert

    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPresented = false
                        }
                    }
                alert()
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .zIndex(1)
            }
        }
    }
}
