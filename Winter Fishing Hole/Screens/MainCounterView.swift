import SwiftUI

struct MainCounterView: View {
    @ObservedObject var dataService = DataService.shared
    @State private var showEndDayAlert = false
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppTheme.spacingL) {
                    // Today's count
                    VStack(spacing: AppTheme.spacingS) {
                        Text("Today")
                            .font(.system(size: AppTheme.fontM, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        Text("\(dataService.todayHoles)")
                            .font(.system(size: AppTheme.fontHuge, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                        
                        if let currentDay = dataService.currentDay, !currentDay.holes.isEmpty {
                            Text("Last hole: \(currentDay.lastHoleTime)")
                                .font(.system(size: AppTheme.fontS))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                    .padding(.top, AppTheme.spacingL)
                    
                    // Big +1 Button
                    BigHoleButton {
                        dataService.addHole()
                        SoundService.shared.playAddHole()
                    }
                    .padding(.vertical, AppTheme.spacingL)
                    
                    // Quick stats
                    VStack(spacing: AppTheme.spacingM) {
                        HStack(spacing: AppTheme.spacingM) {
                            StatCard(
                                title: "This Week",
                                value: "\(dataService.weekHoles)",
                                icon: AnyView(CalendarIcon(size: 18, color: AppTheme.lightBlue))
                            )
                            
                            StatCard(
                                title: "This Season",
                                value: "\(dataService.seasonHoles)",
                                icon: AnyView(DrillIcon(size: 18, color: AppTheme.lightBlue))
                            )
                        }
                        
                        StatCard(
                            title: "Average per Trip",
                            value: String(format: "%.1f", dataService.avgHolesPerTrip),
                            icon: AnyView(ChartIcon(size: 18, color: AppTheme.lightBlue))
                        )
                    }
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // End Day Button
                    if dataService.currentDay != nil {
                        Button(action: { showEndDayAlert = true }) {
                            HStack {
                                CheckIcon(size: 20, color: .white)
                                Text("End Day")
                                    .font(.system(size: AppTheme.fontM, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.spacingM)
                            .background(AppTheme.success)
                            .cornerRadius(AppTheme.radiusM)
                        }
                        .padding(.horizontal, AppTheme.spacingM)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .alert(isPresented: $showEndDayAlert) {
            Alert(
                title: Text("End Day?"),
                message: Text("This will save today's \(dataService.todayHoles) holes to history."),
                primaryButton: .default(Text("End Day")) {
                    dataService.endDay()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
