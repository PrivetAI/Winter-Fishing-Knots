import SwiftUI

struct ExportView: View {
    @State private var showShareSheet = false
    @State private var exportURL: URL?
    @State private var showError = false
    @State private var isExporting = false
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            VStack(spacing: AppTheme.spacingL) {
                // Header
                Text("Export Data")
                    .font(.system(size: AppTheme.fontXL, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(.top, AppTheme.spacingM)
                
                Spacer()
                
                // Export illustration
                VStack(spacing: AppTheme.spacingL) {
                    ExportIcon(size: 80, color: AppTheme.primaryBlue)
                    
                    Text("Export Your Data")
                        .font(.system(size: AppTheme.fontL, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("Export all your drilling data as a CSV file. You can open it in Excel, Google Sheets, or any spreadsheet application.")
                        .font(.system(size: AppTheme.fontS))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.spacingL)
                    
                    // What's included
                    VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                        Text("Includes:")
                            .font(.system(size: AppTheme.fontS, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                        
                        exportItem("Season summary statistics")
                        exportItem("Daily drilling records")
                        exportItem("Hole timestamps")
                        exportItem("Goals and progress")
                        exportItem("Equipment status")
                        exportItem("Water body data")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppTheme.spacingM)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(AppTheme.radiusM)
                }
                .padding(.horizontal, AppTheme.spacingM)
                
                Spacer()
                
                // Export button
                Button(action: exportData) {
                    HStack {
                        if isExporting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            ExportIcon(size: 24, color: .white)
                        }
                        Text(isExporting ? "Exporting..." : "Export to Files")
                            .font(.system(size: AppTheme.fontM, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.spacingM)
                    .background(isExporting ? AppTheme.lightBlue : AppTheme.primaryBlue)
                    .cornerRadius(AppTheme.radiusM)
                }
                .disabled(isExporting)
                .padding(.horizontal, AppTheme.spacingM)
                .padding(.bottom, AppTheme.spacingL)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = exportURL {
                DocumentPicker(url: url)
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Export Failed"),
                message: Text("Unable to create export file. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func exportItem(_ text: String) -> some View {
        HStack(spacing: AppTheme.spacingS) {
            CheckIcon(size: 16, color: AppTheme.success)
            Text(text)
                .font(.system(size: AppTheme.fontS))
                .foregroundColor(AppTheme.textSecondary)
        }
    }
    
    private func exportData() {
        isExporting = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = ExportService.shared.writeCSVToFile() {
                DispatchQueue.main.async {
                    isExporting = false
                    exportURL = url
                    showShareSheet = true
                }
            } else {
                DispatchQueue.main.async {
                    isExporting = false
                    showError = true
                }
            }
        }
    }
}

// MARK: - Document Picker for saving to Files
struct DocumentPicker: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forExporting: [url], asCopy: true)
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}
