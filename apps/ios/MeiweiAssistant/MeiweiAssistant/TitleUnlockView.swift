import SwiftUI

struct TitleUnlockOverlay: View {
    let presentation: TitleUnlockPresentation
    let onDismiss: () -> Void

    private var accent: Color {
        switch presentation.kind {
        case let .main(quality): quality.primaryColor
        case .hidden: Color(red: 0.93, green: 0.69, blue: 0.37)
        case .completion: AppTheme.moss
        }
    }

    private var symbol: String {
        switch presentation.kind {
        case .main: "crown.fill"
        case .hidden: "sparkles"
        case .completion: "checkmark"
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.56)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            VStack(spacing: 16) {
                Image(systemName: symbol)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(accent)
                    .frame(width: 74, height: 74)
                    .background(AppTheme.ink, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .shadow(color: .black.opacity(0.18), radius: 22, y: 12)

                Text(presentation.kicker.uppercased())
                    .font(.caption2.weight(.heavy))
                    .tracking(2.2)
                    .foregroundStyle(AppTheme.accent)

                Text(presentation.title)
                    .font(.system(size: 27, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppTheme.ink)

                Text(presentation.message)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                if let nextMessage = presentation.nextMessage {
                    Text(nextMessage)
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 11)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.045), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }

                Button("收下称号", action: onDismiss)
                    .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
            .frame(maxWidth: 360)
            .background(AppTheme.canvas, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(.white.opacity(0.75), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.30), radius: 50, y: 26)
            .padding(24)
            .transition(.scale(scale: 0.92).combined(with: .opacity))
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }
}
