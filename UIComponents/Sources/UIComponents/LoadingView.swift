import SwiftUI

public struct LoadingView: View {
	var message: String = "Carregando..."

	public init(message: String = "Carregando...") {
		self.message = message
	}

	public var body: some View {
		VStack(spacing: 12) {
			ProgressView()
				.progressViewStyle(.circular)
				.tint(Color.appPink)
				.scaleEffect(1.1)

			Text(message)
				.font(.subheadline)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity)
		.padding(24)
		.background(Color(.secondarySystemBackground))
		.clipShape(RoundedRectangle(cornerRadius: 16))
	}
}
