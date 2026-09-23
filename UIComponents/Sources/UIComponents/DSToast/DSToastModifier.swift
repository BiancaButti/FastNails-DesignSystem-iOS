import SwiftUI

struct DSToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let dotColor: Color
    let duration: TimeInterval
    
    var delayTask: (@escaping () -> Void) -> Void = { block in
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run { block() }
        }
    }

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    DSToast(message: message, dotColor: dotColor)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .zIndex(1)
                .onAppear {
                    delayTask {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}
