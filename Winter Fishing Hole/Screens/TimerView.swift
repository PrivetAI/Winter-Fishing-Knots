import SwiftUI

struct TimerView: View {
    @ObservedObject var dataService = DataService.shared
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            AppTheme.iceBackground.ignoresSafeArea()
            
            VStack(spacing: AppTheme.spacingL) {
                // Header
                Text("Timer Mode")
                    .font(.system(size: AppTheme.fontXL, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(.top, AppTheme.spacingM)
                
                if let session = dataService.timerSession {
                    // Active session
                    VStack(spacing: AppTheme.spacingL) {
                        // Timer display
                        VStack(spacing: AppTheme.spacingS) {
                            Text(formatElapsedTime(elapsedTime))
                                .font(.system(size: 48, weight: .bold, design: .monospaced))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Text("Session started at \(formatTime(session.startTime))")
                                .font(.system(size: AppTheme.fontS))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(AppTheme.spacingL)
                        .cardStyle()
                        
                        // Hole count and button
                        VStack(spacing: AppTheme.spacingM) {
                            Text("\(session.holes.count)")
                                .font(.system(size: AppTheme.fontHuge, weight: .bold))
                                .foregroundColor(AppTheme.primaryBlue)
                            
                            Text("holes drilled")
                                .font(.system(size: AppTheme.fontM))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            BigHoleButton {
                                dataService.addTimerHole()
                                SoundService.shared.playAddHole()
                            }
                        }
                        
                        // Intervals
                        if session.holes.count > 1 {
                            VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                                SectionHeader(title: "Intervals")
                                
                                IntervalChart(intervals: session.holes.enumerated().compactMap { index, hole in
                                    guard index > 0 else { return nil }
                                    return hole.timestamp.timeIntervalSince(session.holes[index - 1].timestamp)
                                })
                                
                                // Last intervals
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppTheme.spacingS) {
                                        ForEach(Array(session.holes.suffix(10).enumerated()), id: \.element.id) { index, hole in
                                            VStack(spacing: 2) {
                                                Text("#\(session.holes.count - 10 + index + 1)")
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
                            }
                            .padding(AppTheme.spacingM)
                            .cardStyle()
                        }
                        
                        // End session
                        PrimaryButton(title: "End Timer Session", isDestructive: true) {
                            stopTimer()
                            dataService.endTimer()
                        }
                    }
                    .padding(.horizontal, AppTheme.spacingM)
                    .onAppear {
                        startTimer(from: session.startTime)
                    }
                    .onDisappear {
                        stopTimer()
                    }
                } else {
                    // No active session
                    VStack(spacing: AppTheme.spacingL) {
                        TimerIcon(size: 80, color: AppTheme.lightBlue)
                        
                        Text("Track Your Drilling")
                            .font(.system(size: AppTheme.fontL, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Text("Start a timer session to record exact timestamps for each hole. See your drilling intervals and find your most productive times.")
                            .font(.system(size: AppTheme.fontS))
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppTheme.spacingL)
                        
                        PrimaryButton(title: "Start Timer Session") {
                            dataService.startTimer()
                        }
                        .padding(.horizontal, AppTheme.spacingM)
                    }
                    .padding(AppTheme.spacingXL)
                }
                
                Spacer()
            }
        }
    }
    
    private func startTimer(from startTime: Date) {
        updateElapsedTime(from: startTime)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateElapsedTime(from: startTime)
        }
    }
    
    private func updateElapsedTime(from startTime: Date) {
        elapsedTime = Date().timeIntervalSince(startTime)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func formatElapsedTime(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
