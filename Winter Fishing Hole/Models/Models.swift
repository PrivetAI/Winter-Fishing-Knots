import Foundation

// MARK: - Hole Record
struct HoleRecord: Codable, Identifiable {
    let id: UUID
    let timestamp: Date
    
    init(id: UUID = UUID(), timestamp: Date = Date()) {
        self.id = id
        self.timestamp = timestamp
    }
}

// MARK: - Fishing Day
struct FishingDay: Codable, Identifiable {
    let id: UUID
    var date: Date
    var holes: [HoleRecord]
    var startTime: Date?
    var endTime: Date?
    var notes: String
    var waterBodyId: UUID?
    var iceThickness: Double?
    var drillType: DrillType
    
    init(id: UUID = UUID(), date: Date = Date(), holes: [HoleRecord] = [], startTime: Date? = nil, endTime: Date? = nil, notes: String = "", waterBodyId: UUID? = nil, iceThickness: Double? = nil, drillType: DrillType = .electric) {
        self.id = id
        self.date = date
        self.holes = holes
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
        self.waterBodyId = waterBodyId
        self.iceThickness = iceThickness
        self.drillType = drillType
    }
    
    var holesCount: Int { holes.count }
    
    var duration: TimeInterval? {
        guard let start = startTime, let end = endTime else { return nil }
        return end.timeIntervalSince(start)
    }
    
    var durationString: String {
        guard let dur = duration else { return "--:--" }
        let hours = Int(dur) / 3600
        let minutes = (Int(dur) % 3600) / 60
        return String(format: "%d:%02d", hours, minutes)
    }
    
    var holesPerHour: Double {
        guard let dur = duration, dur > 0 else { return 0 }
        return Double(holesCount) / (dur / 3600)
    }
    
    var lastHoleTime: String {
        guard let last = holes.last else { return "--:--" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: last.timestamp)
    }
    
    var intervals: [TimeInterval] {
        guard holes.count > 1 else { return [] }
        var result: [TimeInterval] = []
        for i in 1..<holes.count {
            result.append(holes[i].timestamp.timeIntervalSince(holes[i-1].timestamp))
        }
        return result
    }
}

// MARK: - Drill Type
enum DrillType: String, Codable, CaseIterable {
    case manual = "Manual"
    case electric = "Electric"
    case gas = "Gas"
}

// MARK: - Water Body
struct WaterBody: Codable, Identifiable {
    let id: UUID
    var name: String
    var avgIceThickness: Double?
    var avgDepth: Double?
    var notes: String
    
    init(id: UUID = UUID(), name: String = "", avgIceThickness: Double? = nil, avgDepth: Double? = nil, notes: String = "") {
        self.id = id
        self.name = name
        self.avgIceThickness = avgIceThickness
        self.avgDepth = avgDepth
        self.notes = notes
    }
}

// MARK: - Goal
struct Goal: Codable, Identifiable {
    let id: UUID
    var title: String
    var targetValue: Int
    var goalType: GoalType
    var createdAt: Date
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String = "", targetValue: Int = 0, goalType: GoalType = .season, createdAt: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.targetValue = targetValue
        self.goalType = goalType
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}

enum GoalType: String, Codable, CaseIterable {
    case season = "Season"
    case month = "Month"
    case trip = "Single Trip"
}

// MARK: - Equipment
struct Equipment: Codable {
    var bladeCapacity: Int
    var bladeUsedHoles: Int
    var batteryCapacity: Int
    var lastBladeReplacement: Date?
    
    init(bladeCapacity: Int = 500, bladeUsedHoles: Int = 0, batteryCapacity: Int = 40, lastBladeReplacement: Date? = nil) {
        self.bladeCapacity = bladeCapacity
        self.bladeUsedHoles = bladeUsedHoles
        self.batteryCapacity = batteryCapacity
        self.lastBladeReplacement = lastBladeReplacement
    }
    
    var bladeWearPercentage: Double {
        guard bladeCapacity > 0 else { return 0 }
        return min(100, Double(bladeUsedHoles) / Double(bladeCapacity) * 100)
    }
    
    var remainingBladeHoles: Int {
        max(0, bladeCapacity - bladeUsedHoles)
    }
}

// MARK: - App Settings
struct AppSettings: Codable {
    var autoStartDay: Bool
    var soundEnabled: Bool
    var vibrationEnabled: Bool
    var endDayReminder: Bool
    var seasonStartMonth: Int
    var seasonStartDay: Int
    var seasonEndMonth: Int
    var seasonEndDay: Int
    
    init(autoStartDay: Bool = true, soundEnabled: Bool = true, vibrationEnabled: Bool = true, endDayReminder: Bool = true, seasonStartMonth: Int = 11, seasonStartDay: Int = 1, seasonEndMonth: Int = 4, seasonEndDay: Int = 30) {
        self.autoStartDay = autoStartDay
        self.soundEnabled = soundEnabled
        self.vibrationEnabled = vibrationEnabled
        self.endDayReminder = endDayReminder
        self.seasonStartMonth = seasonStartMonth
        self.seasonStartDay = seasonStartDay
        self.seasonEndMonth = seasonEndMonth
        self.seasonEndDay = seasonEndDay
    }
}

// MARK: - Season Helper
struct SeasonHelper {
    static func currentSeasonRange(settings: AppSettings) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        
        var startYear = currentYear
        var endYear = currentYear
        
        // Season spans across years (e.g., Nov-Apr)
        if settings.seasonStartMonth > settings.seasonEndMonth {
            if currentMonth >= settings.seasonStartMonth {
                endYear = currentYear + 1
            } else {
                startYear = currentYear - 1
            }
        }
        
        let startComponents = DateComponents(year: startYear, month: settings.seasonStartMonth, day: settings.seasonStartDay)
        let endComponents = DateComponents(year: endYear, month: settings.seasonEndMonth, day: settings.seasonEndDay)
        
        let start = calendar.date(from: startComponents) ?? now
        let end = calendar.date(from: endComponents) ?? now
        
        return (start, end)
    }
    
    static func previousSeasonRange(settings: AppSettings) -> (start: Date, end: Date) {
        let current = currentSeasonRange(settings: settings)
        let calendar = Calendar.current
        
        let prevStart = calendar.date(byAdding: .year, value: -1, to: current.start) ?? current.start
        let prevEnd = calendar.date(byAdding: .year, value: -1, to: current.end) ?? current.end
        
        return (prevStart, prevEnd)
    }
}

// MARK: - Timer Session
struct TimerSession: Codable, Identifiable {
    let id: UUID
    var startTime: Date
    var holes: [HoleRecord]
    var isActive: Bool
    
    init(id: UUID = UUID(), startTime: Date = Date(), holes: [HoleRecord] = [], isActive: Bool = true) {
        self.id = id
        self.startTime = startTime
        self.holes = holes
        self.isActive = isActive
    }
}
