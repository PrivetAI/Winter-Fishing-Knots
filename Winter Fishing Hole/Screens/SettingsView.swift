import SwiftUI

struct SettingsView: View {
    @ObservedObject var dataService = DataService.shared
    @State private var showResetAlert = false
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppTheme.spacingL) {
                    // Header
                    Text("Settings")
                        .font(.system(size: AppTheme.fontXL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, AppTheme.spacingM)
                    
                    // General settings
                    VStack(spacing: 0) {
                        SectionHeader(title: "General")
                            .padding(.bottom, AppTheme.spacingS)
                        
                        CustomToggle(
                            title: "Auto-start Day",
                            isOn: Binding(
                                get: { dataService.settings.autoStartDay },
                                set: { 
                                    dataService.settings.autoStartDay = $0
                                    dataService.saveAll()
                                }
                            ),
                            subtitle: "Create new day on first hole"
                        )
                        
                        Divider().padding(.vertical, AppTheme.spacingS)
                        
                        CustomToggle(
                            title: "Sound",
                            isOn: Binding(
                                get: { dataService.settings.soundEnabled },
                                set: { 
                                    dataService.settings.soundEnabled = $0
                                    dataService.saveAll()
                                }
                            ),
                            subtitle: "Play sound when adding hole"
                        )
                        
                        Divider().padding(.vertical, AppTheme.spacingS)
                        
                        CustomToggle(
                            title: "Vibration",
                            isOn: Binding(
                                get: { dataService.settings.vibrationEnabled },
                                set: { 
                                    dataService.settings.vibrationEnabled = $0
                                    dataService.saveAll()
                                }
                            ),
                            subtitle: "Haptic feedback when adding hole"
                        )
                        
                        Divider().padding(.vertical, AppTheme.spacingS)
                        
                        CustomToggle(
                            title: "End Day Reminder",
                            isOn: Binding(
                                get: { dataService.settings.endDayReminder },
                                set: { 
                                    dataService.settings.endDayReminder = $0
                                    dataService.saveAll()
                                }
                            ),
                            subtitle: "Remind to end day if forgotten"
                        )
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // Season settings
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Season Dates")
                        
                        HStack(spacing: AppTheme.spacingM) {
                            VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                                Text("Start")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                HStack {
                                    monthPicker(
                                        value: Binding(
                                            get: { dataService.settings.seasonStartMonth },
                                            set: { 
                                                dataService.settings.seasonStartMonth = $0
                                                dataService.saveAll()
                                            }
                                        )
                                    )
                                    
                                    dayPicker(
                                        value: Binding(
                                            get: { dataService.settings.seasonStartDay },
                                            set: { 
                                                dataService.settings.seasonStartDay = $0
                                                dataService.saveAll()
                                            }
                                        )
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                                Text("End")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                HStack {
                                    monthPicker(
                                        value: Binding(
                                            get: { dataService.settings.seasonEndMonth },
                                            set: { 
                                                dataService.settings.seasonEndMonth = $0
                                                dataService.saveAll()
                                            }
                                        )
                                    )
                                    
                                    dayPicker(
                                        value: Binding(
                                            get: { dataService.settings.seasonEndDay },
                                            set: { 
                                                dataService.settings.seasonEndDay = $0
                                                dataService.saveAll()
                                            }
                                        )
                                    )
                                }
                            }
                        }
                        
                        Text("Season: \(monthName(dataService.settings.seasonStartMonth)) \(dataService.settings.seasonStartDay) - \(monthName(dataService.settings.seasonEndMonth)) \(dataService.settings.seasonEndDay)")
                            .font(.system(size: AppTheme.fontS))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // Data management
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Data")
                        
                        let stats = dataStats()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Days")
                                    .font(.system(size: AppTheme.fontXS))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text("\(stats.days)")
                                    .font(.system(size: AppTheme.fontM, weight: .semibold))
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Holes")
                                    .font(.system(size: AppTheme.fontXS))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text("\(stats.holes)")
                                    .font(.system(size: AppTheme.fontM, weight: .semibold))
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Water Bodies")
                                    .font(.system(size: AppTheme.fontXS))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text("\(stats.waterBodies)")
                                    .font(.system(size: AppTheme.fontM, weight: .semibold))
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                        }
                        
                        PrimaryButton(title: "Reset All Data", isDestructive: true) {
                            showResetAlert = true
                        }
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // App info
                    VStack(spacing: AppTheme.spacingS) {
                        Text("Winter Fishing Hole")
                            .font(.system(size: AppTheme.fontM, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text("Version 1.0")
                            .font(.system(size: AppTheme.fontS))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(AppTheme.spacingM)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset All Data?"),
                message: Text("This will permanently delete all your drilling history, goals, water bodies, and equipment data. This action cannot be undone."),
                primaryButton: .destructive(Text("Reset")) {
                    dataService.resetAllData()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func monthPicker(value: Binding<Int>) -> some View {
        Menu {
            ForEach(1...12, id: \.self) { month in
                Button(monthName(month)) {
                    value.wrappedValue = month
                }
            }
        } label: {
            Text(monthName(value.wrappedValue))
                .font(.system(size: AppTheme.fontS))
                .foregroundColor(AppTheme.textPrimary)
                .padding(.horizontal, AppTheme.spacingM)
                .padding(.vertical, AppTheme.spacingS)
                .background(AppTheme.iceBackground)
                .cornerRadius(AppTheme.radiusS)
        }
    }
    
    private func dayPicker(value: Binding<Int>) -> some View {
        Menu {
            ForEach(1...31, id: \.self) { day in
                Button("\(day)") {
                    value.wrappedValue = day
                }
            }
        } label: {
            Text("\(value.wrappedValue)")
                .font(.system(size: AppTheme.fontS))
                .foregroundColor(AppTheme.textPrimary)
                .padding(.horizontal, AppTheme.spacingM)
                .padding(.vertical, AppTheme.spacingS)
                .background(AppTheme.iceBackground)
                .cornerRadius(AppTheme.radiusS)
        }
    }
    
    private func monthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        var components = DateComponents()
        components.month = month
        if let date = Calendar.current.date(from: components) {
            return formatter.string(from: date)
        }
        return ""
    }
    
    private func dataStats() -> (days: Int, holes: Int, waterBodies: Int) {
        let days = dataService.fishingDays.count
        let holes = dataService.fishingDays.reduce(0) { $0 + $1.holesCount }
        let waterBodies = dataService.waterBodies.count
        return (days, holes, waterBodies)
    }
}
