import SwiftUI

// MARK: - My Rigs View
struct MyRigsView: View {
    @ObservedObject var dataService: DataService
    @State private var selectedRig: CustomRig?
    @State private var showDeleteConfirm = false
    @State private var rigToDelete: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                BlueprintSectionHeader(title: "My Saved Rigs")

                if dataService.customRigs.isEmpty {
                    EmptyStateView(
                        iconShape: AnyShape(StarIcon()),
                        message: "No saved rigs yet.\nBuild a rig and save it here."
                    )
                } else {
                    // Stats summary
                    if dataService.customRigs.contains(where: { $0.catchCount > 0 }) {
                        BlueprintCard {
                            Text("Top Performers")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .foregroundColor(AppTheme.warmAccent)
                                .padding(.bottom, 4)
                            CatchBarChart(rigs: dataService.customRigs)
                        }
                    }

                    ForEach(dataService.customRigs) { rig in
                        rigRow(rig)
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(16)
        }
        .background(AppTheme.surfaceBg)
        .sheet(item: $selectedRig) { rig in
            RigEditSheet(rig: rig, dataService: dataService)
        }
        .alert(isPresented: $showDeleteConfirm) {
            Alert(
                title: Text("Delete Rig"),
                message: Text("This cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let id = rigToDelete {
                        dataService.deleteRig(id: id)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }

    @ViewBuilder
    func rigRow(_ rig: CustomRig) -> some View {
        BlueprintCard {
            HStack(spacing: 12) {
                // Component count badge
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppTheme.deepNavy)
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(AppTheme.accent, lineWidth: AppTheme.thinLine)
                        )
                    VStack(spacing: 1) {
                        Text("\(rig.components.count)")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(AppTheme.accent)
                        Text("parts")
                            .font(.system(size: 7, design: .monospaced))
                            .foregroundColor(AppTheme.iceBlue)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(rig.name)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.frostWhite)

                    StarRatingView(rating: rig.rating) { newRating in
                        dataService.updateRating(id: rig.id, rating: newRating)
                    }

                    HStack(spacing: 12) {
                        Text("Catches: \(rig.catchCount)")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(AppTheme.iceBlue)
                        if let last = rig.lastUsed {
                            Text("Last: \(formatDate(last))")
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(AppTheme.iceBlue.opacity(0.7))
                        }
                    }
                }

                Spacer()

                VStack(spacing: 8) {
                    Button(action: { selectedRig = rig }) {
                        GearIcon()
                            .stroke(AppTheme.iceBlue, lineWidth: AppTheme.medLine)
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: { dataService.incrementCatch(id: rig.id) }) {
                        PlusIcon()
                            .fill(AppTheme.success)
                            .frame(width: 16, height: 16)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        rigToDelete = rig.id
                        showDeleteConfirm = true
                    }) {
                        TrashIcon()
                            .stroke(AppTheme.danger.opacity(0.6), lineWidth: AppTheme.medLine)
                            .frame(width: 14, height: 14)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.locale = Locale(identifier: "en_US")
        return f.string(from: date)
    }
}

// MARK: - Rig Edit Sheet
struct RigEditSheet: View {
    @State var rig: CustomRig
    @ObservedObject var dataService: DataService
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    BlueprintCard {
                        Text("Rig Name")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        TextField("Name", text: $rig.name)
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(AppTheme.frostWhite)
                            .padding(8)
                            .background(AppTheme.deepNavy)
                            .cornerRadius(4)
                    }

                    BlueprintCard {
                        Text("Notes")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        TextEditor(text: $rig.notes)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AppTheme.frostWhite)
                            .frame(minHeight: 80)
                            .padding(4)
                            .background(AppTheme.deepNavy)
                            .cornerRadius(4)
                    }

                    BlueprintCard {
                        Text("Rating")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        StarRatingView(rating: rig.rating) { rig.rating = $0 }
                    }

                    BlueprintCard {
                        Text("Components")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        ForEach(rig.components) { comp in
                            HStack(spacing: 8) {
                                ComponentIconView(type: comp.type, size: 18)
                                Text("\(comp.label) - \(comp.detail)")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(AppTheme.frostWhite)
                            }
                            .padding(.vertical, 2)
                        }
                    }

                    // Export text
                    BlueprintCard {
                        Text("Export")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        Text(ExportService.rigToText(rig))
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(AppTheme.iceBlue)
                            .textSelection(.enabled)
                    }
                }
                .padding(16)
            }
            .background(AppTheme.surfaceBg.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Edit Rig", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                        .foregroundColor(AppTheme.iceBlue)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dataService.saveRig(rig)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppTheme.accent)
                }
            }
        }
        .forcedAppearance()
    }
}

extension CustomRig: Equatable {
    static func == (lhs: CustomRig, rhs: CustomRig) -> Bool { lhs.id == rhs.id }
}
