import SwiftUI

struct EquipmentView: View {
    @ObservedObject var dataService = DataService.shared
    @State private var showResetAlert = false
    @State private var bladeCapacity: Int = 500
    @State private var batteryCapacity: Int = 40
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppTheme.spacingL) {
                    // Header
                    Text("Equipment")
                        .font(.system(size: AppTheme.fontXL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, AppTheme.spacingM)
                    
                    // Blade wear section
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Blade Wear")
                        
                        // Progress circle
                        HStack {
                            PieProgress(
                                progress: dataService.equipment.bladeWearPercentage,
                                size: 100,
                                color: wearColor
                            )
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: AppTheme.spacingS) {
                                Text("\(dataService.equipment.bladeUsedHoles)")
                                    .font(.system(size: AppTheme.fontXL, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)
                                Text("of \(dataService.equipment.bladeCapacity) holes")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                Text("\(dataService.equipment.remainingBladeHoles) remaining")
                                    .font(.system(size: AppTheme.fontM, weight: .semibold))
                                    .foregroundColor(wearColor)
                            }
                        }
                        
                        // Estimate replacement
                        if let replacementDate = dataService.estimatedBladeReplacementDate() {
                            HStack {
                                CalendarIcon(size: 20, color: AppTheme.lightBlue)
                                Text("Estimated replacement: \(formatDate(replacementDate))")
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                        
                        // Capacity setting
                        CustomNumberField(
                            title: "Blade Capacity (holes)",
                            value: Binding(
                                get: { dataService.equipment.bladeCapacity },
                                set: { 
                                    dataService.equipment.bladeCapacity = $0
                                    dataService.saveAll()
                                }
                            ),
                            range: 50...2000
                        )
                        
                        // Reset button
                        PrimaryButton(title: "Blades Replaced") {
                            showResetAlert = true
                        }
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // Battery section
                    VStack(spacing: AppTheme.spacingM) {
                        SectionHeader(title: "Battery")
                        
                        CustomNumberField(
                            title: "Battery Capacity (holes per charge)",
                            value: Binding(
                                get: { dataService.equipment.batteryCapacity },
                                set: { 
                                    dataService.equipment.batteryCapacity = $0
                                    dataService.saveAll()
                                }
                            ),
                            range: 5...200
                        )
                        
                        // Charges needed
                        let chargesNeeded = dataService.chargesNeededForTrip()
                        
                        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                            Text("For Next Trip")
                                .font(.system(size: AppTheme.fontS, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            HStack {
                                Text("\(chargesNeeded)")
                                    .font(.system(size: AppTheme.fontXL, weight: .bold))
                                    .foregroundColor(AppTheme.primaryBlue)
                                
                                Text("charges needed")
                                    .font(.system(size: AppTheme.fontM))
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                            
                            Text("Based on avg \(String(format: "%.1f", dataService.avgHolesPerTrip)) holes/trip")
                                .font(.system(size: AppTheme.fontXS))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.spacingM)
                        .background(AppTheme.iceBackground)
                        .cornerRadius(AppTheme.radiusM)
                    }
                    .padding(AppTheme.spacingM)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.spacingM)
                    
                    // Last replacement info
                    if let lastReplacement = dataService.equipment.lastBladeReplacement {
                        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                            Text("Last Blade Replacement")
                                .font(.system(size: AppTheme.fontS, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            Text(formatDate(lastReplacement))
                                .font(.system(size: AppTheme.fontM))
                                .foregroundColor(AppTheme.textPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.spacingM)
                        .cardStyle()
                        .padding(.horizontal, AppTheme.spacingM)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset Blade Counter?"),
                message: Text("This will reset the hole count to 0 after blade replacement."),
                primaryButton: .default(Text("Reset")) {
                    dataService.resetBlades()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var wearColor: Color {
        let wear = dataService.equipment.bladeWearPercentage
        if wear >= 80 {
            return AppTheme.danger
        } else if wear >= 50 {
            return AppTheme.warning
        } else {
            return AppTheme.success
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}
