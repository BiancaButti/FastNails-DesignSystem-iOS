import SwiftUI

struct LoadingView: View {
	var message: String = "Carregando..."

	var body: some View {
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
