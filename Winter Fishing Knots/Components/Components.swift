import SwiftUI

// MARK: - Custom Segmented Top Bar
struct SegmentedTopBar: View {
    @Binding var selected: AppTab
    let tabs: [AppTab]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                ForEach(tabs, id: \.rawValue) { tab in
                    Button(action: {
                        HapticService.selection()
                        withAnimation(.easeInOut(duration: 0.2)) { selected = tab }
                    }) {
                        VStack(spacing: 4) {
                            tabIcon(tab)
                                .frame(width: 18, height: 18)
                            Text(tab.rawValue)
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(selected == tab ? AppTheme.slateBlue : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(selected == tab ? AppTheme.accent : AppTheme.gridLine,
                                        lineWidth: selected == tab ? AppTheme.medLine : AppTheme.thinLine)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(selected == tab ? AppTheme.frostWhite : AppTheme.iceBlue)
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 6)
        .background(AppTheme.deepNavy)
    }

    @ViewBuilder
    func tabIcon(_ tab: AppTab) -> some View {
        switch tab {
        case .rigBuilder: RigBuilderIcon().stroke(lineWidth: AppTheme.medLine)
        case .knots: KnotSymbolIcon().stroke(lineWidth: AppTheme.medLine)
        case .library: BookIcon().stroke(lineWidth: AppTheme.medLine)
        case .myRigs: StarIcon().stroke(lineWidth: AppTheme.medLine)
        case .calculator: CalculatorIcon().stroke(lineWidth: AppTheme.medLine)
        }
    }
}

// MARK: - Blueprint Card
struct BlueprintCard<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding(AppTheme.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(AppTheme.cardBg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(AppTheme.gridLine, lineWidth: AppTheme.thinLine)
        )
    }
}

// MARK: - Star Rating
struct StarRatingView: View {
    let rating: Int
    let maxRating: Int
    var onTap: ((Int) -> Void)?

    init(rating: Int, maxRating: Int = 5, onTap: ((Int) -> Void)? = nil) {
        self.rating = rating
        self.maxRating = maxRating
        self.onTap = onTap
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { star in
                StarIcon()
                    .fill(star <= rating ? AppTheme.warmAccent : AppTheme.gridLine)
                    .frame(width: 18, height: 18)
                    .onTapGesture {
                        onTap?(star)
                    }
            }
        }
    }
}

// MARK: - Difficulty Dots
struct DifficultyView: View {
    let level: Int
    let maxLevel: Int

    init(_ level: Int, max: Int = 5) {
        self.level = level
        self.maxLevel = max
    }

    var body: some View {
        HStack(spacing: 3) {
            ForEach(1...maxLevel, id: \.self) { i in
                Circle()
                    .fill(i <= level ? difficultyColor : AppTheme.gridLine)
                    .frame(width: 8, height: 8)
            }
        }
    }

    var difficultyColor: Color {
        switch level {
        case 1...2: return AppTheme.success
        case 3: return AppTheme.warmAccent
        default: return AppTheme.danger
        }
    }
}

// MARK: - Strength Bar
struct StrengthBar: View {
    let percent: Int

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(AppTheme.gridLine)
                RoundedRectangle(cornerRadius: 3)
                    .fill(barColor)
                    .frame(width: geo.size.width * CGFloat(percent) / 100.0)
            }
        }
        .frame(height: 6)
    }

    var barColor: Color {
        switch percent {
        case 0..<70: return AppTheme.danger
        case 70..<85: return AppTheme.warmAccent
        default: return AppTheme.success
        }
    }
}

// MARK: - Section Header
struct BlueprintSectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Rectangle().fill(AppTheme.accent).frame(width: 3, height: 14)
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundColor(AppTheme.frostWhite)
                .tracking(1)
                .textCase(.uppercase)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Blueprint Grid Background
struct GridBackground: View {
    let spacing: CGFloat

    init(spacing: CGFloat = 20) {
        self.spacing = spacing
    }

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let cols = Int(geo.size.width / spacing)
                let rows = Int(geo.size.height / spacing)
                for i in 0...cols {
                    let x = CGFloat(i) * spacing
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geo.size.height))
                }
                for j in 0...rows {
                    let y = CGFloat(j) * spacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                }
            }
            .stroke(AppTheme.gridLine, lineWidth: 0.3)
        }
    }
}

// MARK: - Empty State
struct EmptyStateView: View {
    let iconShape: AnyShape
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            iconShape
                .stroke(AppTheme.gridLine, lineWidth: AppTheme.medLine)
                .frame(width: 50, height: 50)
            Text(message)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(AppTheme.iceBlue.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

// Type-erased Shape wrapper for iOS 15
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    init<S: Shape>(_ shape: S) {
        _path = { shape.path(in: $0) }
    }
    func path(in rect: CGRect) -> Path { _path(rect) }
}
