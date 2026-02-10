import SwiftUI

struct StatisticsView: View {
    @ObservedObject var dataService = DataService.shared
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppTheme.spacingL) {
                    // Header
                    Text("Statistics")
                        .font(.system(size: AppTheme.fontXL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, AppTheme.spacingM)
                    
                    // Season overview
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Season Overview")
                        
                        // Big number
                        VStack(spacing: AppTheme.spacingS) {
                            Text("\(dataService.seasonHoles)")
                                .font(.system(size: 64, weight: .bold))
                                .foregroundColor(AppTheme.primaryBlue)
                            Text("Total Holes This Season")
                                .font(.system(size: AppTheme.fontS))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(AppTheme.spacingL)
                        .cardStyle()
                        
                        HStack(spacing: AppTheme.spacingM) {
                            StatCard(title: "Trips", value: "\(dataService.tripCount)")
                            StatCard(title: "Avg/Trip", value: String(format: "%.1f", dataService.avgHolesPerTrip))
                        }
                        
                        HStack(spacing: AppTheme.spacingM) {
                            if let record = dataService.recordDay {
                                VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                                    HStack {
                                        TargetIcon(size: 18, color: AppTheme.success)
                                        Text("Record Day")
                                            .font(.system(size: AppTheme.fontS, weight: .medium))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    Text("\(record.holesCount) holes")
                                        .font(.system(size: AppTheme.fontL, weight: .bold))
                                        .foregroundColor(AppTheme.success)
                                    Text(formatShortDate(record.date))
                                        .font(.system(size: AppTheme.fontXS))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTheme.spacingM)
                                .cardStyle()
                            }
                            
                            if let lowest = dataService.lowestDay {
                                VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                                    HStack {
                                        ChartIcon(size: 18, color: AppTheme.warning)
                                        Text("Lowest Day")
                                            .font(.system(size: AppTheme.fontS, weight: .medium))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    Text("\(lowest.holesCount) holes")
                                        .font(.system(size: AppTheme.fontL, weight: .bold))
                                        .foregroundColor(AppTheme.warning)
                                    Text(formatShortDate(lowest.date))
                                        .font(.system(size: AppTheme.fontXS))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTheme.spacingM)
                                .cardStyle()
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // Weekly chart
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Weekly Activity")
                        
                        let weeklyData = dataService.weeklyStats()
                        
                        if weeklyData.isEmpty || weeklyData.allSatisfy({ $0.holes == 0 }) {
                            Text("No data yet")
                                .font(.system(size: AppTheme.fontS))
                                .foregroundColor(AppTheme.textSecondary)
                                .frame(height: 150)
                        } else {
                            BarChart(
                                data: weeklyData.map { (label: "W\($0.week)", value: Double($0.holes)) },
                                barColor: AppTheme.primaryBlue
                            )
                        }
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // Day of week distribution
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Day of Week")
                        
                        let dayData = dataService.dayOfWeekStats()
                        
                        if dayData.allSatisfy({ $0.avgHoles == 0 }) {
                            Text("No data yet")
                                .font(.system(size: AppTheme.fontS))
                                .foregroundColor(AppTheme.textSecondary)
                                .frame(height: 150)
                        } else {
                            BarChart(
                                data: dayData.map { (label: $0.day, value: $0.avgHoles) },
                                barColor: AppTheme.teal
                            )
                            
                            if let bestDay = dayData.max(by: { $0.avgHoles < $1.avgHoles }), bestDay.avgHoles > 0 {
                                Text("Best day: \(bestDay.day) with avg \(String(format: "%.1f", bestDay.avgHoles)) holes")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // Drilling tempo
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Drilling Tempo")
                        
                        HStack(spacing: AppTheme.spacingM) {
                            VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                                Text("Average Speed")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text(String(format: "%.1f holes/hr", dataService.avgDrillingSpeed))
                                    .font(.system(size: AppTheme.fontL, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                            
                            Spacer()
                            
                            if let best = dataService.bestDrillingSpeed {
                                VStack(alignment: .trailing, spacing: AppTheme.spacingS) {
                                    Text("Best Speed")
                                        .font(.system(size: AppTheme.fontS))
                                        .foregroundColor(AppTheme.textSecondary)
                                    Text(String(format: "%.1f holes/hr", best.speed))
                                        .font(.system(size: AppTheme.fontL, weight: .bold))
                                        .foregroundColor(AppTheme.success)
                                    Text(formatShortDate(best.date))
                                        .font(.system(size: AppTheme.fontXS))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                            }
                        }
                        
                        // Speed trend
                        let speeds = dataService.fishingDays
                            .sorted { $0.date < $1.date }
                            .suffix(10)
                            .map { $0.holesPerHour }
                        
                        if speeds.count > 1 {
                            LineChart(
                                data: speeds,
                                labels: nil,
                                lineColor: AppTheme.primaryBlue
                            )
                        }
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
    
    private func formatShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
