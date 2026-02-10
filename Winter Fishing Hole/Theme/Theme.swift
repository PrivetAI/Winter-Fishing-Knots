import SwiftUI

// MARK: - App Theme
struct AppTheme {
    // Colors
    static let primaryBlue = Color(red: 0.118, green: 0.533, blue: 0.898)
    static let darkBlue = Color(red: 0.102, green: 0.137, blue: 0.494)
    static let lightBlue = Color(red: 0.361, green: 0.420, blue: 0.753)
    static let iceBackground = Color(red: 0.961, green: 0.976, blue: 1.0)
    static let cardBackground = Color.white
    static let teal = Color(red: 0.0, green: 0.675, blue: 0.757)
    static let danger = Color(red: 0.937, green: 0.325, blue: 0.314)
    static let success = Color(red: 0.4, green: 0.733, blue: 0.416)
    static let warning = Color(red: 1.0, green: 0.596, blue: 0.0)
    static let textPrimary = Color(red: 0.102, green: 0.137, blue: 0.494)
    static let textSecondary = Color(red: 0.361, green: 0.420, blue: 0.753)
    static let divider = Color(red: 0.9, green: 0.92, blue: 0.96)
    
    // Gradient
    static let primaryGradient = LinearGradient(
        colors: [primaryBlue, teal],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let iceGradient = LinearGradient(
        colors: [Color(red: 0.9, green: 0.95, blue: 1.0), Color(red: 0.85, green: 0.92, blue: 1.0)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Spacing
    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32
    
    // Corner Radius
    static let radiusS: CGFloat = 8
    static let radiusM: CGFloat = 12
    static let radiusL: CGFloat = 16
    static let radiusXL: CGFloat = 24
    
    // Shadows
    static let shadowColor = Color.black.opacity(0.08)
    static let shadowRadius: CGFloat = 8
    static let shadowY: CGFloat = 4
    
    // Font sizes
    static let fontHuge: CGFloat = 72
    static let fontXL: CGFloat = 32
    static let fontL: CGFloat = 24
    static let fontM: CGFloat = 18
    static let fontS: CGFloat = 14
    static let fontXS: CGFloat = 12
}

// MARK: - View Modifiers
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.radiusL)
            .shadow(color: AppTheme.shadowColor, radius: AppTheme.shadowRadius, x: 0, y: AppTheme.shadowY)
    }
}

struct GradientButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .background(AppTheme.primaryGradient)
            .cornerRadius(AppTheme.radiusM)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func gradientButton() -> some View {
        modifier(GradientButtonStyle())
    }
}
