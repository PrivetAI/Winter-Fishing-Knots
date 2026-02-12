import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .rigBuilder
    @StateObject private var dataService = DataService.shared
    @State private var showAbout = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HookIcon()
                    .stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
                    .frame(width: 20, height: 20)
                Text("WINTER FISHING HOLE")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(AppTheme.frostWhite)
                    .tracking(1.5)
                Spacer()
                Button(action: { showAbout = true }) {
                    GearIcon()
                        .stroke(AppTheme.iceBlue, lineWidth: AppTheme.medLine)
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(AppTheme.deepNavy)

            // Segmented navigation
            SegmentedTopBar(selected: $selectedTab, tabs: AppTab.allCases)

            // Thin separator
            Rectangle()
                .fill(AppTheme.gridLine)
                .frame(height: 0.5)

            // Content
            Group {
                switch selectedTab {
                case .rigBuilder:
                    RigBuilderView(dataService: dataService)
                case .knots:
                    KnotListView()
                case .library:
                    RigLibraryView()
                case .myRigs:
                    MyRigsView(dataService: dataService)
                case .calculator:
                    LineCalculatorView()
                }
            }
        }
        .background(AppTheme.surfaceBg.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}
