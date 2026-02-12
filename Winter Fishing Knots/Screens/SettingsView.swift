import SwiftUI

// MARK: - About / Info View (accessible from gear icon in header)
struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // App logo area
                    ZStack {
                        GridBackground(spacing: 12)
                        VStack(spacing: 8) {
                            HookIcon()
                                .stroke(AppTheme.accent, lineWidth: 2)
                                .frame(width: 50, height: 50)
                            Text("WINTER FISHING HOLE")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(AppTheme.frostWhite)
                                .tracking(2)
                            Text("Knot & Rig Builder")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(AppTheme.iceBlue)
                            Text("Version 1.0")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(AppTheme.iceBlue.opacity(0.5))
                        }
                    }
                    .frame(height: 180)
                    .background(AppTheme.deepNavy)
                    .cornerRadius(AppTheme.cornerRadius)

                    BlueprintCard {
                        Text("About")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        Text("Interactive ice fishing knot-tying guide and rig builder. Learn to tie essential fishing knots with step-by-step visual instructions. Build, save, and rate your custom ice fishing rigs.")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(AppTheme.frostWhite)
                            .padding(.top, 4)
                    }

                    BlueprintCard {
                        Text("Features")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        featureRow("12+ detailed fishing knots with illustrations")
                        featureRow("8 pre-built ice fishing rig templates")
                        featureRow("Custom rig builder with visual diagrams")
                        featureRow("Save, rate, and track your rigs")
                        featureRow("Line calculator for species and conditions")
                        featureRow("Blueprint-style technical diagrams")
                    }

                    BlueprintCard {
                        Text("Data")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        Text("All data is stored locally on your device. No account required. No data collection.")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(AppTheme.frostWhite)
                            .padding(.top, 4)
                    }

                    Spacer(minLength: 20)
                }
                .padding(16)
            }
            .background(AppTheme.surfaceBg.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("About", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                        .foregroundColor(AppTheme.accent)
                }
            }
        }
        .forcedAppearance()
    }

    @ViewBuilder
    func featureRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(AppTheme.accent)
                .frame(width: 5, height: 5)
                .padding(.top, 5)
            Text(text)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(AppTheme.frostWhite)
        }
        .padding(.top, 2)
    }
}
