import SwiftUI

struct GoalsView: View {
    @ObservedObject var dataService = DataService.shared
    @State private var showAddGoal = false
    @State private var editingGoal: Goal?
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Goals")
                        .font(.system(size: AppTheme.fontXL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showAddGoal = true }) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.primaryBlue)
                                .frame(width: 40, height: 40)
                            PlusIcon(size: 20, color: .white)
                        }
                    }
                }
                .padding(AppTheme.spacingM)
                .background(AppTheme.cardBackground)
                
                // Goals list
                if dataService.goals.isEmpty {
                    Spacer()
                    EmptyState(
                        icon: AnyView(TargetIcon(size: 60, color: AppTheme.lightBlue)),
                        title: "No goals yet",
                        message: "Set goals to track your drilling progress throughout the season."
                    )
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.spacingM) {
                            ForEach(dataService.goals) { goal in
                                Button(action: { editingGoal = goal }) {
                                    GoalCard(
                                        goal: goal,
                                        progress: dataService.goalProgress(goal)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Forecast section
                            if let activeGoal = dataService.goals.first(where: { dataService.goalProgress($0).percentage < 100 }) {
                                let progress = dataService.goalProgress(activeGoal)
                                let remaining = activeGoal.targetValue - progress.current
                                
                                if remaining > 0 && dataService.avgHolesPerTrip > 0 {
                                    let tripsNeeded = ceil(Double(remaining) / dataService.avgHolesPerTrip)
                                    let daysNeeded = Int(tripsNeeded * 7) // Assume weekly trips
                                    
                                    VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                                        Text("Forecast")
                                            .font(.system(size: AppTheme.fontM, weight: .semibold))
                                            .foregroundColor(AppTheme.textPrimary)
                                        
                                        Text("At current pace (\(String(format: "%.1f", dataService.avgHolesPerTrip)) holes/trip), you need ~\(Int(tripsNeeded)) more trips (~\(daysNeeded) days) to reach \"\(activeGoal.title)\"")
                                            .font(.system(size: AppTheme.fontS))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(AppTheme.spacingM)
                                    .cardStyle()
                                }
                            }
                        }
                        .padding(AppTheme.spacingM)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddGoal) {
            AddEditGoalView(goal: nil)
        }
        .sheet(item: $editingGoal) { goal in
            AddEditGoalView(goal: goal)
        }
    }
}

// MARK: - Add/Edit Goal View
struct AddEditGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataService = DataService.shared
    
    let goal: Goal?
    
    @State private var title: String = ""
    @State private var targetValue: Int = 100
    @State private var goalType: GoalType = .season
    @State private var showDeleteAlert = false
    
    var isEditing: Bool { goal != nil }
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Cancel")
                            .font(.system(size: AppTheme.fontM))
                            .foregroundColor(AppTheme.primaryBlue)
                    }
                    
                    Spacer()
                    
                    Text(isEditing ? "Edit Goal" : "New Goal")
                        .font(.system(size: AppTheme.fontL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Spacer()
                    
                    Button(action: saveGoal) {
                        Text("Save")
                            .font(.system(size: AppTheme.fontM, weight: .semibold))
                            .foregroundColor(title.isEmpty ? AppTheme.textSecondary : AppTheme.primaryBlue)
                    }
                    .disabled(title.isEmpty)
                }
                .padding(AppTheme.spacingM)
                .background(AppTheme.cardBackground)
                
                ScrollView {
                    VStack(spacing: AppTheme.spacingL) {
                        // Title
                        CustomTextField(
                            title: "Goal Title",
                            text: $title,
                            placeholder: "e.g., Season Goal"
                        )
                        
                        // Target
                        CustomNumberField(
                            title: "Target (holes)",
                            value: $targetValue,
                            range: 1...10000
                        )
                        
                        // Type
                        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                            Text("Goal Type")
                                .font(.system(size: AppTheme.fontS, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            HStack(spacing: AppTheme.spacingS) {
                                ForEach(GoalType.allCases, id: \.self) { type in
                                    Button(action: { goalType = type }) {
                                        Text(type.rawValue)
                                            .font(.system(size: AppTheme.fontS, weight: .medium))
                                            .foregroundColor(goalType == type ? .white : AppTheme.textSecondary)
                                            .padding(.horizontal, AppTheme.spacingM)
                                            .padding(.vertical, AppTheme.spacingS)
                                            .background(goalType == type ? AppTheme.primaryBlue : AppTheme.iceBackground)
                                            .cornerRadius(AppTheme.radiusM)
                                    }
                                }
                            }
                        }
                        
                        // Delete button (only when editing)
                        if isEditing {
                            PrimaryButton(title: "Delete Goal", isDestructive: true) {
                                showDeleteAlert = true
                            }
                            .padding(.top, AppTheme.spacingL)
                        }
                    }
                    .padding(AppTheme.spacingM)
                }
            }
        }
        .onAppear {
            if let goal = goal {
                title = goal.title
                targetValue = goal.targetValue
                goalType = goal.goalType
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Goal?"),
                message: Text("This will permanently delete this goal."),
                primaryButton: .destructive(Text("Delete")) {
                    if let goal = goal {
                        dataService.deleteGoal(goal)
                    }
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func saveGoal() {
        if var editedGoal = goal {
            editedGoal.title = title
            editedGoal.targetValue = targetValue
            editedGoal.goalType = goalType
            dataService.updateGoal(editedGoal)
        } else {
            let newGoal = Goal(
                title: title,
                targetValue: targetValue,
                goalType: goalType
            )
            dataService.addGoal(newGoal)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
