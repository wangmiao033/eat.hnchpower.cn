import SwiftUI

enum AppTheme {
    static let canvas = Color(red: 0.965, green: 0.957, blue: 0.929)
    static let card = Color.white
    static let ink = Color(red: 0.09, green: 0.09, blue: 0.08)
    static let secondary = Color(red: 0.45, green: 0.44, blue: 0.41)
    static let accent = Color(red: 0.84, green: 0.39, blue: 0.23)
    static let moss = Color(red: 0.44, green: 0.49, blue: 0.35)
    static let sand = Color(red: 0.91, green: 0.87, blue: 0.81)
    static let cornerRadius: CGFloat = 24
}

extension View {
    func meiweiCard() -> some View {
        self
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.07), radius: 22, y: 10)
    }
}
