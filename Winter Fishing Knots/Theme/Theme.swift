import SwiftUI

// MARK: - Blueprint Theme
struct AppTheme {
    // Primary palette - cool blues & slate grays
    static let deepNavy = Color(red: 0.08, green: 0.12, blue: 0.22)
    static let slateBlue = Color(red: 0.18, green: 0.25, blue: 0.38)
    static let iceBlue = Color(red: 0.35, green: 0.55, blue: 0.75)
    static let frostWhite = Color(red: 0.85, green: 0.90, blue: 0.95)
    static let gridLine = Color(red: 0.25, green: 0.35, blue: 0.50).opacity(0.3)
    static let accent = Color(red: 0.40, green: 0.70, blue: 0.90)
    static let warmAccent = Color(red: 0.90, green: 0.65, blue: 0.30)
    static let danger = Color(red: 0.85, green: 0.30, blue: 0.30)
    static let success = Color(red: 0.30, green: 0.75, blue: 0.50)
    static let cardBg = Color(red: 0.10, green: 0.15, blue: 0.25)
    static let surfaceBg = Color(red: 0.06, green: 0.09, blue: 0.18)

    static let thinLine: CGFloat = 0.5
    static let medLine: CGFloat = 1.0
    static let thickLine: CGFloat = 1.5
    static let cornerRadius: CGFloat = 8
    static let cardPadding: CGFloat = 12
}

// Force light/dark consistency
struct ForcedAppearanceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.preferredColorScheme(.dark)
    }
}

extension View {
    func forcedAppearance() -> some View {
        modifier(ForcedAppearanceModifier())
    }
}
