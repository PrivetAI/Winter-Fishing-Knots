import SwiftUI

struct SeasonCompareView: View {
    @ObservedObject var dataService = DataService.shared
    
    private var currentSeasonData: SeasonData {
        let range = SeasonHelper.currentSeasonRange(settings: dataService.settings)
        let days = dataService.fishingDays.filter { $0.date >= range.start && $0.date <= range.end }
        return calculateSeasonData(days: days)
    }
    
    private var previousSeasonData: SeasonData {
        let range = SeasonHelper.previousSeasonRange(settings: dataService.settings)
        let days = dataService.fishingDays.filter { $0.date >= range.start && $0.date <= range.end }
        return calculateSeasonData(days: days)
    }
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppTheme.spacingL) {
                    // Header
                    Text("Season Comparison")
                        .font(.system(size: AppTheme.fontXL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, AppTheme.spacingM)
                    
                    // Total holes comparison
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Total Holes")
                        
                        ComparisonChart(
                            leftValue: Double(previousSeasonData.totalHoles),
                            rightValue: Double(currentSeasonData.totalHoles),
                            leftLabel: "Last Season",
                            rightLabel: "This Season"
                        )
                        
                        if currentSeasonData.totalHoles > previousSeasonData.totalHoles {
                            HStack {
                                CheckIcon(size: 16, color: AppTheme.success)
                                Text("+\(currentSeasonData.totalHoles - previousSeasonData.totalHoles) more than last season")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.success)
                            }
                        } else if previousSeasonData.totalHoles > currentSeasonData.totalHoles {
                            HStack {
                                Text("\(previousSeasonData.totalHoles - currentSeasonData.totalHoles) behind last season")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.warning)
                            }
                        }
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // Metrics comparison
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Metrics")
                        
                        comparisonRow(
                            title: "Trips",
                            previous: "\(previousSeasonData.tripCount)",
                            current: "\(currentSeasonData.tripCount)"
                        )
                        
                        Divider()
                        
                        comparisonRow(
                            title: "Avg per Trip",
                            previous: String(format: "%.1f", previousSeasonData.avgPerTrip),
                            current: String(format: "%.1f", currentSeasonData.avgPerTrip)
                        )
                        
                        Divider()
                        
                        comparisonRow(
                            title: "Record Day",
                            previous: "\(previousSeasonData.recordHoles)",
                            current: "\(currentSeasonData.recordHoles)"
                        )
                        
                        Divider()
                        
                        comparisonRow(
                            title: "Avg Speed",
                            previous: String(format: "%.1f/hr", previousSeasonData.avgSpeed),
                            current: String(format: "%.1f/hr", currentSeasonData.avgSpeed)
                        )
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // Season dates info
                    VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                        let currentRange = SeasonHelper.currentSeasonRange(settings: dataService.settings)
                        let previousRange = SeasonHelper.previousSeasonRange(settings: dataService.settings)
                        
                        Text("Season Dates")
                            .font(.system(size: AppTheme.fontS, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Previous")
                                    .font(.system(size: AppTheme.fontXS))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text("\(formatDate(previousRange.start)) - \(formatDate(previousRange.end))")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Current")
                                    .font(.system(size: AppTheme.fontXS))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text("\(formatDate(currentRange.start)) - \(formatDate(currentRange.end))")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // No data message
                    if previousSeasonData.totalHoles == 0 && currentSeasonData.totalHoles == 0 {
                        VStack(spacing: AppTheme.spacingM) {
                            CalendarIcon(size: 40, color: AppTheme.lightBlue)
                            Text("No data for comparison yet")
                                .font(.system(size: AppTheme.fontM))
                                .foregroundColor(AppTheme.textSecondary)
                            Text("Start drilling holes to build your season history")
                                .font(.system(size: AppTheme.fontS))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(AppTheme.spacingXL)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
    
    private func comparisonRow(title: String, previous: String, current: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: AppTheme.fontS))
                .foregroundColor(AppTheme.textSecondary)
            
            Spacer()
            
            Text(previous)
                .font(.system(size: AppTheme.fontM, weight: .medium))
                .foregroundColor(AppTheme.lightBlue)
                .frame(width: 80, alignment: .trailing)
            
            Text(current)
                .font(.system(size: AppTheme.fontM, weight: .bold))
                .foregroundColor(AppTheme.primaryBlue)
                .frame(width: 80, alignment: .trailing)
        }
    }
    
    private func calculateSeasonData(days: [FishingDay]) -> SeasonData {
        let totalHoles = days.reduce(0) { $0 + $1.holesCount }
        let tripCount = days.count
        let avgPerTrip = tripCount > 0 ? Double(totalHoles) / Double(tripCount) : 0
        let recordHoles = days.map { $0.holesCount }.max() ?? 0
        let validSpeeds = days.filter { $0.holesPerHour > 0 }
        let avgSpeed = validSpeeds.isEmpty ? 0 : validSpeeds.reduce(0) { $0 + $1.holesPerHour } / Double(validSpeeds.count)
        
        return SeasonData(
            totalHoles: totalHoles,
            tripCount: tripCount,
            avgPerTrip: avgPerTrip,
            recordHoles: recordHoles,
            avgSpeed: avgSpeed
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct SeasonData {
    let totalHoles: Int
    let tripCount: Int
    let avgPerTrip: Double
    let recordHoles: Int
    let avgSpeed: Double
}
