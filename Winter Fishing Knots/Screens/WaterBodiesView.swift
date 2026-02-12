import SwiftUI

// MARK: - Save Rig Sheet
struct SaveRigSheet: View {
    let components: [RigComponent]
    @ObservedObject var dataService: DataService
    var onSaved: () -> Void

    @State private var rigName: String = ""
    @State private var notes: String = ""
    @State private var rating: Int = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    BlueprintCard {
                        Text("Rig Name")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        TextField("Enter rig name", text: $rigName)
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
                        TextEditor(text: $notes)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AppTheme.frostWhite)
                            .frame(minHeight: 60)
                            .padding(4)
                            .background(AppTheme.deepNavy)
                            .cornerRadius(4)
                    }

                    BlueprintCard {
                        Text("Initial Rating")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        StarRatingView(rating: rating) { rating = $0 }
                    }

                    BlueprintCard {
                        Text("Components (\(components.count))")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        ForEach(components) { comp in
                            HStack(spacing: 6) {
                                ComponentIconView(type: comp.type, size: 16)
                                Text("\(comp.label) - \(comp.detail)")
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundColor(AppTheme.frostWhite)
                            }
                            .padding(.vertical, 1)
                        }
                    }

                    Button(action: saveRig) {
                        Text("Save Rig")
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundColor(rigName.isEmpty ? AppTheme.iceBlue.opacity(0.4) : AppTheme.deepNavy)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                    .fill(rigName.isEmpty ? AppTheme.gridLine : AppTheme.accent)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(rigName.isEmpty)
                }
                .padding(16)
            }
            .background(AppTheme.surfaceBg.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Save Custom Rig", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                        .foregroundColor(AppTheme.iceBlue)
                }
            }
        }
        .forcedAppearance()
    }

    private func saveRig() {
        let rig = CustomRig(
            id: UUID().uuidString,
            name: rigName,
            components: components,
            notes: notes,
            rating: rating,
            catchCount: 0,
            dateCreated: Date(),
            lastUsed: nil
        )
        dataService.saveRig(rig)
        HapticService.success()
        onSaved()
    }
}
