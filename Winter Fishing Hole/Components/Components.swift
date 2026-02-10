import SwiftUI

// MARK: - Big Hole Button
struct BigHoleButton: View {
    let action: () -> Void
    @State private var isPressed = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 0.95
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.0
                }
            }
            action()
        }) {
            ZStack {
                // Outer glow
                Circle()
                    .fill(AppTheme.primaryBlue.opacity(0.2))
                    .frame(width: 220, height: 220)
                
                // Main button
                Circle()
                    .fill(AppTheme.primaryGradient)
                    .frame(width: 200, height: 200)
                    .shadow(color: AppTheme.primaryBlue.opacity(0.4), radius: 20, x: 0, y: 10)
                
                // Inner highlight
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.3), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                
                // Content
                VStack(spacing: 8) {
                    PlusIcon(size: 50, color: .white)
                    Text("1 Hole")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .scaleEffect(scale)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: AnyView?
    
    init(title: String, value: String, icon: AnyView? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
            HStack {
                if let icon = icon {
                    icon
                }
                Text(title)
                    .font(.system(size: AppTheme.fontS, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Text(value)
                .font(.system(size: AppTheme.fontL, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.spacingM)
        .cardStyle()
    }
}

// MARK: - Progress Bar
struct ProgressBar: View {
    let progress: Double
    let color: Color
    let height: CGFloat
    
    init(progress: Double, color: Color = AppTheme.primaryBlue, height: CGFloat = 12) {
        self.progress = progress
        self.color = color
        self.height = height
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(AppTheme.divider)
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, min(geo.size.width, geo.size.width * progress / 100)), height: height)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Day Card
struct DayCard: View {
    let day: FishingDay
    let waterBodyName: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatDate(day.date))
                        .font(.system(size: AppTheme.fontM, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    if let name = waterBodyName {
                        Text(name)
                            .font(.system(size: AppTheme.fontS))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(day.holesCount)")
                        .font(.system(size: AppTheme.fontXL, weight: .bold))
                        .foregroundColor(AppTheme.primaryBlue)
                    
                    Text("holes")
                        .font(.system(size: AppTheme.fontXS))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            Divider()
            
            HStack(spacing: AppTheme.spacingL) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Duration")
                        .font(.system(size: AppTheme.fontXS))
                        .foregroundColor(AppTheme.textSecondary)
                    Text(day.durationString)
                        .font(.system(size: AppTheme.fontS, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Speed")
                        .font(.system(size: AppTheme.fontXS))
                        .foregroundColor(AppTheme.textSecondary)
                    Text(String(format: "%.1f/hr", day.holesPerHour))
                        .font(.system(size: AppTheme.fontS, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                if day.startTime != nil {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Time")
                            .font(.system(size: AppTheme.fontXS))
                            .foregroundColor(AppTheme.textSecondary)
                        Text(formatTimeRange(day.startTime, day.endTime))
                            .font(.system(size: AppTheme.fontS, weight: .medium))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                }
            }
        }
        .padding(AppTheme.spacingM)
        .cardStyle()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    private func formatTimeRange(_ start: Date?, _ end: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let startStr = start != nil ? formatter.string(from: start!) : "--:--"
        let endStr = end != nil ? formatter.string(from: end!) : "--:--"
        return "\(startStr)-\(endStr)"
    }
}

// MARK: - Goal Card
struct GoalCard: View {
    let goal: Goal
    let progress: (current: Int, percentage: Double)
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
            HStack {
                TargetIcon(size: 20, color: progressColor)
                
                Text(goal.title)
                    .font(.system(size: AppTheme.fontM, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Text(goal.goalType.rawValue)
                    .font(.system(size: AppTheme.fontXS))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppTheme.lightBlue)
                    .cornerRadius(AppTheme.radiusS)
            }
            
            ProgressBar(progress: progress.percentage, color: progressColor)
            
            HStack {
                Text("\(progress.current) / \(goal.targetValue)")
                    .font(.system(size: AppTheme.fontS, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Text(String(format: "%.0f%%", progress.percentage))
                    .font(.system(size: AppTheme.fontS, weight: .bold))
                    .foregroundColor(progressColor)
            }
        }
        .padding(AppTheme.spacingM)
        .cardStyle()
    }
    
    private var progressColor: Color {
        if progress.percentage >= 100 {
            return AppTheme.success
        } else if progress.percentage >= 50 {
            return AppTheme.primaryBlue
        } else {
            return AppTheme.warning
        }
    }
}

// MARK: - Water Body Card
struct WaterBodyCard: View {
    let waterBody: WaterBody
    let stats: (visits: Int, totalHoles: Int, avgHoles: Double)
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
            HStack {
                WaterIcon(size: 24, color: AppTheme.primaryBlue)
                
                Text(waterBody.name)
                    .font(.system(size: AppTheme.fontM, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
            }
            
            HStack(spacing: AppTheme.spacingL) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Visits")
                        .font(.system(size: AppTheme.fontXS))
                        .foregroundColor(AppTheme.textSecondary)
                    Text("\(stats.visits)")
                        .font(.system(size: AppTheme.fontS, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total Holes")
                        .font(.system(size: AppTheme.fontXS))
                        .foregroundColor(AppTheme.textSecondary)
                    Text("\(stats.totalHoles)")
                        .font(.system(size: AppTheme.fontS, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Avg/Visit")
                        .font(.system(size: AppTheme.fontXS))
                        .foregroundColor(AppTheme.textSecondary)
                    Text(String(format: "%.1f", stats.avgHoles))
                        .font(.system(size: AppTheme.fontS, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
            
            if let thickness = waterBody.avgIceThickness {
                HStack {
                    Text("Avg Ice: \(Int(thickness)) cm")
                        .font(.system(size: AppTheme.fontXS))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    if let depth = waterBody.avgDepth {
                        Text("Avg Depth: \(Int(depth)) m")
                            .font(.system(size: AppTheme.fontXS))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
        }
        .padding(AppTheme.spacingM)
        .cardStyle()
    }
}

// MARK: - Custom Text Field
struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
            Text(title)
                .font(.system(size: AppTheme.fontS, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
            
            TextField(placeholder, text: $text)
                .font(.system(size: AppTheme.fontM))
                .foregroundColor(AppTheme.textPrimary)
                .padding(AppTheme.spacingM)
                .background(AppTheme.iceBackground)
                .cornerRadius(AppTheme.radiusM)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radiusM)
                        .stroke(AppTheme.divider, lineWidth: 1)
                )
        }
    }
}

// MARK: - Custom Number Field
struct CustomNumberField: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
            Text(title)
                .font(.system(size: AppTheme.fontS, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
            
            HStack {
                Button(action: {
                    if value > range.lowerBound {
                        value -= 1
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.iceBackground)
                            .frame(width: 44, height: 44)
                        Text("-")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppTheme.primaryBlue)
                    }
                }
                
                Spacer()
                
                Text("\(value)")
                    .font(.system(size: AppTheme.fontL, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Button(action: {
                    if value < range.upperBound {
                        value += 1
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.primaryBlue)
                            .frame(width: 44, height: 44)
                        Text("+")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(AppTheme.spacingM)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.radiusM)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.radiusM)
                    .stroke(AppTheme.divider, lineWidth: 1)
            )
        }
    }
}

// MARK: - Custom Toggle
struct CustomToggle: View {
    let title: String
    @Binding var isOn: Bool
    let subtitle: String?
    
    init(title: String, isOn: Binding<Bool>, subtitle: String? = nil) {
        self.title = title
        self._isOn = isOn
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: AppTheme.fontM, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: AppTheme.fontXS))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: { isOn.toggle() }) {
                ZStack {
                    Capsule()
                        .fill(isOn ? AppTheme.primaryBlue : AppTheme.divider)
                        .frame(width: 51, height: 31)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 27, height: 27)
                        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
                        .offset(x: isOn ? 10 : -10)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .animation(.spring(response: 0.3), value: isOn)
        }
        .padding(AppTheme.spacingM)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.radiusM)
    }
}

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isDestructive: Bool
    
    init(title: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: AppTheme.fontM, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.spacingM)
                .background(isDestructive ? AppTheme.danger : AppTheme.primaryBlue)
                .cornerRadius(AppTheme.radiusM)
        }
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: AppTheme.fontM, weight: .semibold))
                .foregroundColor(AppTheme.primaryBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.spacingM)
                .background(AppTheme.iceBackground)
                .cornerRadius(AppTheme.radiusM)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radiusM)
                        .stroke(AppTheme.primaryBlue, lineWidth: 2)
                )
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: AppTheme.fontM, weight: .bold))
            .foregroundColor(AppTheme.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Empty State
struct EmptyState: View {
    let icon: AnyView
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: AppTheme.spacingM) {
            icon
                .opacity(0.5)
            
            Text(title)
                .font(.system(size: AppTheme.fontL, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text(message)
                .font(.system(size: AppTheme.fontS))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppTheme.spacingXL)
    }
}

// MARK: - Navigation Bar
struct CustomNavBar: View {
    let title: String
    let showBack: Bool
    let backAction: (() -> Void)?
    let rightIcon: AnyView?
    let rightAction: (() -> Void)?
    
    init(title: String, showBack: Bool = false, backAction: (() -> Void)? = nil, rightIcon: AnyView? = nil, rightAction: (() -> Void)? = nil) {
        self.title = title
        self.showBack = showBack
        self.backAction = backAction
        self.rightIcon = rightIcon
        self.rightAction = rightAction
    }
    
    var body: some View {
        HStack {
            if showBack {
                Button(action: { backAction?() }) {
                    ArrowLeftIcon(size: 28, color: AppTheme.primaryBlue)
                        .frame(width: 44, height: 44)
                }
            } else {
                Spacer()
                    .frame(width: 44)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: AppTheme.fontL, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
            
            if let rightIcon = rightIcon {
                Button(action: { rightAction?() }) {
                    rightIcon
                        .frame(width: 44, height: 44)
                }
            } else {
                Spacer()
                    .frame(width: 44)
            }
        }
        .padding(.horizontal, AppTheme.spacingM)
        .padding(.vertical, AppTheme.spacingS)
        .background(AppTheme.cardBackground)
    }
}
