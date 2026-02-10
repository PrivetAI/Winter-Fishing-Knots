import SwiftUI

struct HistoryView: View {
    @ObservedObject var dataService = DataService.shared
    @State private var sortByDate = true
    @State private var selectedDay: FishingDay?
    
    private var sortedDays: [FishingDay] {
        if sortByDate {
            return dataService.fishingDays.sorted { $0.date > $1.date }
        } else {
            return dataService.fishingDays.sorted { $0.holesCount > $1.holesCount }
        }
    }
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: AppTheme.spacingM) {
                    Text("History")
                        .font(.system(size: AppTheme.fontXL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    // Sort toggle
                    HStack(spacing: AppTheme.spacingM) {
                        sortButton(title: "By Date", isSelected: sortByDate) {
                            sortByDate = true
                        }
                        sortButton(title: "By Holes", isSelected: !sortByDate) {
                            sortByDate = false
                        }
                    }
                }
                .padding(AppTheme.spacingM)
                .background(AppTheme.cardBackground)
                
                // List
                if sortedDays.isEmpty {
                    Spacer()
                    EmptyState(
                        icon: AnyView(HistoryIcon(size: 60, color: AppTheme.lightBlue)),
                        title: "No history yet",
                        message: "Start drilling holes and end your day to see them here."
                    )
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.spacingM) {
                            ForEach(sortedDays) { day in
                                Button(action: { selectedDay = day }) {
                                    DayCard(
                                        day: day,
                                        waterBodyName: dataService.waterBodies.first(where: { $0.id == day.waterBodyId })?.name
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(AppTheme.spacingM)
                    }
                }
            }
        }
        .sheet(item: $selectedDay) { day in
            DayDetailView(day: day)
        }
    }
    
    private func sortButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: AppTheme.fontS, weight: .medium))
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .padding(.horizontal, AppTheme.spacingM)
                .padding(.vertical, AppTheme.spacingS)
                .background(isSelected ? AppTheme.primaryBlue : AppTheme.iceBackground)
                .cornerRadius(AppTheme.radiusM)
        }
    }
}

// MARK: - Day Detail View
struct DayDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataService = DataService.shared
    @State var day: FishingDay
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    @State private var editedNotes: String = ""
    @State private var editedHolesCount: String = ""
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        ArrowLeftIcon(size: 28, color: AppTheme.primaryBlue)
                    }
                    
                    Spacer()
                    
                    Text(formatDate(day.date))
                        .font(.system(size: AppTheme.fontL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Spacer()
                    
                    if isEditing {
                        Button(action: saveChanges) {
                            CheckIcon(size: 28, color: AppTheme.success)
                        }
                    } else {
                        Button(action: { startEditing() }) {
                            EditIcon(size: 24, color: AppTheme.primaryBlue)
                        }
                    }
                }
                .padding(AppTheme.spacingM)
                .background(AppTheme.cardBackground)
                
                ScrollView {
                    VStack(spacing: AppTheme.spacingM) {
                        // Summary card
                        VStack(spacing: AppTheme.spacingM) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Total Holes")
                                        .font(.system(size: AppTheme.fontS))
                                        .foregroundColor(AppTheme.textSecondary)
                                    
                                    if isEditing {
                                        TextField("", text: $editedHolesCount)
                                            .keyboardType(.numberPad)
                                            .font(.system(size: AppTheme.fontXL, weight: .bold))
                                            .foregroundColor(AppTheme.primaryBlue)
                                    } else {
                                        Text("\(day.holesCount)")
                                            .font(.system(size: AppTheme.fontXL, weight: .bold))
                                            .foregroundColor(AppTheme.primaryBlue)
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Speed")
                                        .font(.system(size: AppTheme.fontS))
                                        .foregroundColor(AppTheme.textSecondary)
                                    Text(String(format: "%.1f/hr", day.holesPerHour))
                                        .font(.system(size: AppTheme.fontL, weight: .semibold))
                                        .foregroundColor(AppTheme.textPrimary)
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                infoItem(title: "Duration", value: day.durationString)
                                Spacer()
                                infoItem(title: "Start", value: formatTime(day.startTime))
                                Spacer()
                                infoItem(title: "End", value: formatTime(day.endTime))
                            }
                        }
                        .padding(AppTheme.spacingM)
                        .cardStyle()
                        
                        // Water body and drill type
                        if let waterBody = dataService.waterBodies.first(where: { $0.id == day.waterBodyId }) {
                            HStack {
                                WaterIcon(size: 20, color: AppTheme.primaryBlue)
                                Text(waterBody.name)
                                    .font(.system(size: AppTheme.fontM))
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                            }
                            .padding(AppTheme.spacingM)
                            .cardStyle()
                        }
                        
                        // Notes
                        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                            Text("Notes")
                                .font(.system(size: AppTheme.fontM, weight: .semibold))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            if isEditing {
                                TextEditor(text: $editedNotes)
                                    .frame(minHeight: 100)
                                    .padding(AppTheme.spacingS)
                                    .background(AppTheme.iceBackground)
                                    .cornerRadius(AppTheme.radiusM)
                            } else {
                                Text(day.notes.isEmpty ? "No notes" : day.notes)
                                    .font(.system(size: AppTheme.fontS))
                                    .foregroundColor(day.notes.isEmpty ? AppTheme.textSecondary : AppTheme.textPrimary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.spacingM)
                        .cardStyle()
                        
                        // Hole timestamps
                        if !day.holes.isEmpty {
                            VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                                Text("Hole Timestamps")
                                    .font(.system(size: AppTheme.fontM, weight: .semibold))
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: AppTheme.spacingS) {
                                    ForEach(Array(day.holes.enumerated()), id: \.element.id) { index, hole in
                                        VStack(spacing: 2) {
                                            Text("#\(index + 1)")
                                                .font(.system(size: AppTheme.fontXS))
                                                .foregroundColor(AppTheme.textSecondary)
                                            Text(formatTime(hole.timestamp))
                                                .font(.system(size: AppTheme.fontS, weight: .medium))
                                                .foregroundColor(AppTheme.textPrimary)
                                        }
                                        .padding(AppTheme.spacingS)
                                        .background(AppTheme.iceBackground)
                                        .cornerRadius(AppTheme.radiusS)
                                    }
                                }
                            }
                            .padding(AppTheme.spacingM)
                            .cardStyle()
                        }
                        
                        // Delete button
                        Button(action: { showDeleteAlert = true }) {
                            HStack {
                                TrashIcon(size: 20, color: .white)
                                Text("Delete Day")
                                    .font(.system(size: AppTheme.fontM, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.spacingM)
                            .background(AppTheme.danger)
                            .cornerRadius(AppTheme.radiusM)
                        }
                    }
                    .padding(AppTheme.spacingM)
                }
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Day?"),
                message: Text("This will permanently delete this day's data."),
                primaryButton: .destructive(Text("Delete")) {
                    dataService.deleteDay(day)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func startEditing() {
        editedNotes = day.notes
        editedHolesCount = "\(day.holesCount)"
        isEditing = true
    }
    
    private func saveChanges() {
        day.notes = editedNotes
        if let newCount = Int(editedHolesCount), newCount != day.holesCount {
            // Adjust holes array
            if newCount > day.holesCount {
                for _ in 0..<(newCount - day.holesCount) {
                    day.holes.append(HoleRecord())
                }
            } else {
                day.holes = Array(day.holes.prefix(newCount))
            }
        }
        dataService.updateDay(day)
        isEditing = false
    }
    
    private func infoItem(title: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: AppTheme.fontXS))
                .foregroundColor(AppTheme.textSecondary)
            Text(value)
                .font(.system(size: AppTheme.fontS, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date?) -> String {
        guard let date = date else { return "--:--" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
