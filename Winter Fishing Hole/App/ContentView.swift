import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showMoreMenu = false
    
    var body: some View {
        ZStack {
            // Main content
            Group {
                switch selectedTab {
                case 0:
                    MainCounterView()
                case 1:
                    HistoryView()
                case 2:
                    StatisticsView()
                case 3:
                    MoreMenuView(selectedTab: $selectedTab)
                default:
                    MainCounterView()
                }
            }
            
            // Custom Tab Bar
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    tabButton(icon: AnyView(HoleIcon(size: 24, color: selectedTab == 0 ? AppTheme.primaryBlue : AppTheme.textSecondary)), title: "Counter", index: 0)
                    tabButton(icon: AnyView(HistoryIcon(size: 24, color: selectedTab == 1 ? AppTheme.primaryBlue : AppTheme.textSecondary)), title: "History", index: 1)
                    tabButton(icon: AnyView(ChartIcon(size: 24, color: selectedTab == 2 ? AppTheme.primaryBlue : AppTheme.textSecondary)), title: "Stats", index: 2)
                    tabButton(icon: AnyView(MenuIcon(size: 24, color: selectedTab == 3 ? AppTheme.primaryBlue : AppTheme.textSecondary)), title: "More", index: 3)
                }
                .padding(.top, AppTheme.spacingM)
                .padding(.bottom, 24)
                .background(
                    AppTheme.cardBackground
                        .shadow(color: AppTheme.shadowColor, radius: 10, x: 0, y: -5)
                )
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    private func tabButton(icon: AnyView, title: String, index: Int) -> some View {
        Button(action: { selectedTab = index }) {
            VStack(spacing: 4) {
                icon
                Text(title)
                    .font(.system(size: AppTheme.fontXS, weight: selectedTab == index ? .semibold : .regular))
                    .foregroundColor(selectedTab == index ? AppTheme.primaryBlue : AppTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - More Menu View
struct MoreMenuView: View {
    @Binding var selectedTab: Int
    @State private var activeScreen: MoreScreen?
    
    enum MoreScreen: Identifiable {
        case equipment, timer, goals, waterBodies, seasonCompare, export, settings
        var id: Int { hashValue }
    }
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            if let screen = activeScreen {
                // Show selected screen with back navigation
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { activeScreen = nil }) {
                            ArrowLeftIcon(size: 28, color: AppTheme.primaryBlue)
                        }
                        Spacer()
                    }
                    .padding(AppTheme.spacingM)
                    .background(AppTheme.cardBackground)
                    
                    Group {
                        switch screen {
                        case .equipment:
                            EquipmentView()
                        case .timer:
                            TimerView()
                        case .goals:
                            GoalsView()
                        case .waterBodies:
                            WaterBodiesView()
                        case .seasonCompare:
                            SeasonCompareView()
                        case .export:
                            ExportView()
                        case .settings:
                            SettingsView()
                        }
                    }
                }
            } else {
                // Menu list
                ScrollView {
                    VStack(spacing: AppTheme.spacingM) {
                        Text("More")
                            .font(.system(size: AppTheme.fontXL, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, AppTheme.spacingM)
                        
                        menuItem(
                            icon: AnyView(GearIcon(size: 24, color: AppTheme.primaryBlue)),
                            title: "Equipment",
                            subtitle: "Track blade and battery wear",
                            screen: .equipment
                        )
                        
                        menuItem(
                            icon: AnyView(TimerIcon(size: 24, color: AppTheme.primaryBlue)),
                            title: "Timer Mode",
                            subtitle: "Detailed drilling tracking",
                            screen: .timer
                        )
                        
                        menuItem(
                            icon: AnyView(TargetIcon(size: 24, color: AppTheme.primaryBlue)),
                            title: "Goals",
                            subtitle: "Set and track your targets",
                            screen: .goals
                        )
                        
                        menuItem(
                            icon: AnyView(WaterIcon(size: 24, color: AppTheme.primaryBlue)),
                            title: "Water Bodies",
                            subtitle: "Manage fishing locations",
                            screen: .waterBodies
                        )
                        
                        menuItem(
                            icon: AnyView(CalendarIcon(size: 24, color: AppTheme.primaryBlue)),
                            title: "Season Comparison",
                            subtitle: "Compare with last season",
                            screen: .seasonCompare
                        )
                        
                        menuItem(
                            icon: AnyView(ExportIcon(size: 24, color: AppTheme.primaryBlue)),
                            title: "Export Data",
                            subtitle: "Save data as CSV",
                            screen: .export
                        )
                        
                        menuItem(
                            icon: AnyView(SettingsIcon(size: 24, color: AppTheme.primaryBlue)),
                            title: "Settings",
                            subtitle: "App preferences",
                            screen: .settings
                        )
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppTheme.spacingM)
                }
            }
        }
    }
    
    private func menuItem(icon: AnyView, title: String, subtitle: String, screen: MoreScreen) -> some View {
        Button(action: { activeScreen = screen }) {
            HStack(spacing: AppTheme.spacingM) {
                ZStack {
                    Circle()
                        .fill(AppTheme.iceBackground)
                        .frame(width: 48, height: 48)
                    icon
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: AppTheme.fontM, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text(subtitle)
                        .font(.system(size: AppTheme.fontS))
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                ArrowLeftIcon(size: 20, color: AppTheme.textSecondary)
                    .rotationEffect(.degrees(180))
            }
            .padding(AppTheme.spacingM)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.radiusM)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
