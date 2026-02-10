import SwiftUI

struct WaterBodiesView: View {
    @ObservedObject var dataService = DataService.shared
    @State private var showAddWaterBody = false
    @State private var editingWaterBody: WaterBody?
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Water Bodies")
                        .font(.system(size: AppTheme.fontXL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showAddWaterBody = true }) {
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
                
                // List
                if dataService.waterBodies.isEmpty {
                    Spacer()
                    EmptyState(
                        icon: AnyView(WaterIcon(size: 60, color: AppTheme.lightBlue)),
                        title: "No water bodies yet",
                        message: "Add your favorite fishing spots to track statistics for each location."
                    )
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.spacingM) {
                            ForEach(dataService.waterBodies) { waterBody in
                                Button(action: { editingWaterBody = waterBody }) {
                                    WaterBodyCard(
                                        waterBody: waterBody,
                                        stats: dataService.waterBodyStats(waterBody.id)
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
        .sheet(isPresented: $showAddWaterBody) {
            AddEditWaterBodyView(waterBody: nil)
        }
        .sheet(item: $editingWaterBody) { waterBody in
            AddEditWaterBodyView(waterBody: waterBody)
        }
    }
}

// MARK: - Add/Edit Water Body View
struct AddEditWaterBodyView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataService = DataService.shared
    
    let waterBody: WaterBody?
    
    @State private var name: String = ""
    @State private var avgIceThickness: String = ""
    @State private var avgDepth: String = ""
    @State private var notes: String = ""
    @State private var showDeleteAlert = false
    
    var isEditing: Bool { waterBody != nil }
    
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
                    
                    Text(isEditing ? "Edit" : "New Water Body")
                        .font(.system(size: AppTheme.fontL, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Spacer()
                    
                    Button(action: saveWaterBody) {
                        Text("Save")
                            .font(.system(size: AppTheme.fontM, weight: .semibold))
                            .foregroundColor(name.isEmpty ? AppTheme.textSecondary : AppTheme.primaryBlue)
                    }
                    .disabled(name.isEmpty)
                }
                .padding(AppTheme.spacingM)
                .background(AppTheme.cardBackground)
                
                ScrollView {
                    VStack(spacing: AppTheme.spacingL) {
                        // Name
                        CustomTextField(
                            title: "Name",
                            text: $name,
                            placeholder: "e.g., Lake Michigan"
                        )
                        
                        // Ice thickness
                        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                            Text("Average Ice Thickness (cm)")
                                .font(.system(size: AppTheme.fontS, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            TextField("Optional", text: $avgIceThickness)
                                .keyboardType(.numberPad)
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
                        
                        // Depth
                        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                            Text("Average Depth (m)")
                                .font(.system(size: AppTheme.fontS, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            TextField("Optional", text: $avgDepth)
                                .keyboardType(.decimalPad)
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
                        
                        // Notes
                        VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                            Text("Notes")
                                .font(.system(size: AppTheme.fontS, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            TextEditor(text: $notes)
                                .frame(minHeight: 100)
                                .font(.system(size: AppTheme.fontM))
                                .padding(AppTheme.spacingS)
                                .background(AppTheme.iceBackground)
                                .cornerRadius(AppTheme.radiusM)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.radiusM)
                                        .stroke(AppTheme.divider, lineWidth: 1)
                                )
                        }
                        
                        // Delete button (only when editing)
                        if isEditing {
                            PrimaryButton(title: "Delete Water Body", isDestructive: true) {
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
            if let waterBody = waterBody {
                name = waterBody.name
                if let thickness = waterBody.avgIceThickness {
                    avgIceThickness = String(Int(thickness))
                }
                if let depth = waterBody.avgDepth {
                    avgDepth = String(format: "%.1f", depth)
                }
                notes = waterBody.notes
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Water Body?"),
                message: Text("This will permanently delete this water body."),
                primaryButton: .destructive(Text("Delete")) {
                    if let waterBody = waterBody {
                        dataService.deleteWaterBody(waterBody)
                    }
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func saveWaterBody() {
        let thickness = Double(avgIceThickness)
        let depth = Double(avgDepth)
        
        if var editedWaterBody = waterBody {
            editedWaterBody.name = name
            editedWaterBody.avgIceThickness = thickness
            editedWaterBody.avgDepth = depth
            editedWaterBody.notes = notes
            dataService.updateWaterBody(editedWaterBody)
        } else {
            let newWaterBody = WaterBody(
                name: name,
                avgIceThickness: thickness,
                avgDepth: depth,
                notes: notes
            )
            dataService.addWaterBody(newWaterBody)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
