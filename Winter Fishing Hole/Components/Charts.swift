import SwiftUI

// MARK: - Bar Chart
struct BarChart: View {
    let data: [(label: String, value: Double)]
    let maxValue: Double?
    let barColor: Color
    
    init(data: [(label: String, value: Double)], maxValue: Double? = nil, barColor: Color = AppTheme.primaryBlue) {
        self.data = data
        self.maxValue = maxValue
        self.barColor = barColor
    }
    
    private var computedMax: Double {
        maxValue ?? (data.map { $0.value }.max() ?? 1)
    }
    
    var body: some View {
        VStack(spacing: AppTheme.spacingS) {
            GeometryReader { geo in
                HStack(alignment: .bottom, spacing: geo.size.width / CGFloat(data.count * 3)) {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                        VStack(spacing: 4) {
                            if item.value > 0 {
                                Text("\(Int(item.value))")
                                    .font(.system(size: AppTheme.fontXS, weight: .medium))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [barColor, barColor.opacity(0.7)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(
                                    width: max(20, (geo.size.width / CGFloat(data.count)) * 0.6),
                                    height: computedMax > 0 ? max(4, (geo.size.height - 40) * (item.value / computedMax)) : 4
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 150)
            
            // Labels
            HStack {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    Text(item.label)
                        .font(.system(size: AppTheme.fontXS))
                        .foregroundColor(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Line Chart
struct LineChart: View {
    let data: [Double]
    let labels: [String]?
    let lineColor: Color
    let showDots: Bool
    
    init(data: [Double], labels: [String]? = nil, lineColor: Color = AppTheme.primaryBlue, showDots: Bool = true) {
        self.data = data
        self.labels = labels
        self.lineColor = lineColor
        self.showDots = showDots
    }
    
    private var maxValue: Double {
        data.max() ?? 1
    }
    
    private var minValue: Double {
        data.min() ?? 0
    }
    
    private var range: Double {
        max(maxValue - minValue, 1)
    }
    
    var body: some View {
        VStack(spacing: AppTheme.spacingS) {
            GeometryReader { geo in
                ZStack {
                    // Grid lines
                    VStack(spacing: 0) {
                        ForEach(0..<4) { _ in
                            Divider()
                            Spacer()
                        }
                        Divider()
                    }
                    
                    // Line
                    if data.count > 1 {
                        Path { path in
                            let stepX = geo.size.width / CGFloat(data.count - 1)
                            
                            for (index, value) in data.enumerated() {
                                let x = CGFloat(index) * stepX
                                let normalizedValue = (value - minValue) / range
                                let y = geo.size.height - (CGFloat(normalizedValue) * geo.size.height)
                                
                                if index == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(
                            LinearGradient(
                                colors: [lineColor, lineColor.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                        )
                        
                        // Dots
                        if showDots {
                            ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                                let stepX = geo.size.width / CGFloat(data.count - 1)
                                let x = CGFloat(index) * stepX
                                let normalizedValue = (value - minValue) / range
                                let y = geo.size.height - (CGFloat(normalizedValue) * geo.size.height)
                                
                                Circle()
                                    .fill(lineColor)
                                    .frame(width: 8, height: 8)
                                    .position(x: x, y: y)
                            }
                        }
                    }
                }
            }
            .frame(height: 120)
            
            // Labels
            if let labels = labels {
                HStack {
                    ForEach(Array(labels.enumerated()), id: \.offset) { _, label in
                        Text(label)
                            .font(.system(size: AppTheme.fontXS))
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

// MARK: - Interval Chart (for timer)
struct IntervalChart: View {
    let intervals: [TimeInterval]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
            if intervals.isEmpty {
                Text("No interval data yet")
                    .font(.system(size: AppTheme.fontS))
                    .foregroundColor(AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                let maxInterval = intervals.max() ?? 1
                
                GeometryReader { geo in
                    HStack(alignment: .bottom, spacing: 2) {
                        ForEach(Array(intervals.enumerated()), id: \.offset) { index, interval in
                            let height = CGFloat(interval / maxInterval) * geo.size.height
                            
                            VStack(spacing: 2) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(intervalColor(interval, max: maxInterval))
                                    .frame(height: max(4, height))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(height: 80)
                
                // Legend
                HStack(spacing: AppTheme.spacingM) {
                    legendItem(color: AppTheme.success, text: "Fast")
                    legendItem(color: AppTheme.warning, text: "Normal")
                    legendItem(color: AppTheme.danger, text: "Slow")
                }
            }
        }
    }
    
    private func intervalColor(_ interval: TimeInterval, max: TimeInterval) -> Color {
        let ratio = interval / max
        if ratio < 0.4 {
            return AppTheme.success
        } else if ratio < 0.7 {
            return AppTheme.warning
        } else {
            return AppTheme.danger
        }
    }
    
    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(text)
                .font(.system(size: AppTheme.fontXS))
                .foregroundColor(AppTheme.textSecondary)
        }
    }
}

// MARK: - Comparison Chart
struct ComparisonChart: View {
    let leftValue: Double
    let rightValue: Double
    let leftLabel: String
    let rightLabel: String
    
    private var maxValue: Double {
        max(leftValue, rightValue, 1)
    }
    
    var body: some View {
        HStack(spacing: AppTheme.spacingL) {
            // Left bar
            VStack(spacing: AppTheme.spacingS) {
                Text(leftLabel)
                    .font(.system(size: AppTheme.fontS, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                
                GeometryReader { geo in
                    VStack {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppTheme.lightBlue)
                            .frame(height: max(10, geo.size.height * CGFloat(leftValue / maxValue)))
                    }
                }
                
                Text("\(Int(leftValue))")
                    .font(.system(size: AppTheme.fontL, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            
            // Right bar
            VStack(spacing: AppTheme.spacingS) {
                Text(rightLabel)
                    .font(.system(size: AppTheme.fontS, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                
                GeometryReader { geo in
                    VStack {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppTheme.primaryBlue)
                            .frame(height: max(10, geo.size.height * CGFloat(rightValue / maxValue)))
                    }
                }
                
                Text("\(Int(rightValue))")
                    .font(.system(size: AppTheme.fontL, weight: .bold))
                    .foregroundColor(AppTheme.primaryBlue)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 150)
    }
}

// MARK: - Pie Progress
struct PieProgress: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    
    init(progress: Double, size: CGFloat = 100, lineWidth: CGFloat = 12, color: Color = AppTheme.primaryBlue) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(AppTheme.divider, lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress arc
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 100) / 100))
                .stroke(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            
            // Percentage text
            Text(String(format: "%.0f%%", progress))
                .font(.system(size: size * 0.25, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
        }
    }
}
