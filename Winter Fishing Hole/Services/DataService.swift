import Foundation
import SwiftUI

// MARK: - Data Service
class DataService: ObservableObject {
    static let shared = DataService()
    
    @Published var fishingDays: [FishingDay] = []
    @Published var waterBodies: [WaterBody] = []
    @Published var goals: [Goal] = []
    @Published var equipment: Equipment = Equipment()
    @Published var settings: AppSettings = AppSettings()
    @Published var currentDay: FishingDay?
    @Published var timerSession: TimerSession?
    
    private let daysKey = "fishingDays"
    private let waterBodiesKey = "waterBodies"
    private let goalsKey = "goals"
    private let equipmentKey = "equipment"
    private let settingsKey = "appSettings"
    private let currentDayKey = "currentDay"
    private let timerSessionKey = "timerSession"
    
    init() {
        loadAll()
    }
    
    // MARK: - Load
    func loadAll() {
        fishingDays = load(key: daysKey) ?? []
        waterBodies = load(key: waterBodiesKey) ?? []
        goals = load(key: goalsKey) ?? []
        equipment = load(key: equipmentKey) ?? Equipment()
        settings = load(key: settingsKey) ?? AppSettings()
        currentDay = load(key: currentDayKey)
        timerSession = load(key: timerSessionKey)
        
        checkAndResetDay()
    }
    
    private func load<T: Codable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Save
    private func save<T: Codable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func saveAll() {
        save(fishingDays, key: daysKey)
        save(waterBodies, key: waterBodiesKey)
        save(goals, key: goalsKey)
        save(equipment, key: equipmentKey)
        save(settings, key: settingsKey)
        if let cd = currentDay {
            save(cd, key: currentDayKey)
        }
        if let ts = timerSession {
            save(ts, key: timerSessionKey)
        }
    }
    
    // MARK: - Day Management
    private func checkAndResetDay() {
        guard let current = currentDay else { return }
        let calendar = Calendar.current
        if !calendar.isDateInToday(current.date) {
            endDay()
        }
    }
    
    func addHole() {
        let hole = HoleRecord()
        
        if currentDay == nil && settings.autoStartDay {
            startNewDay()
        }
        
        guard var day = currentDay else { return }
        day.holes.append(hole)
        if day.startTime == nil {
            day.startTime = hole.timestamp
        }
        currentDay = day
        
        // Update equipment
        equipment.bladeUsedHoles += 1
        
        saveAll()
    }
    
    func startNewDay() {
        let newDay = FishingDay(date: Date())
        currentDay = newDay
        save(currentDay!, key: currentDayKey)
    }
    
    func endDay() {
        guard var day = currentDay else { return }
        day.endTime = Date()
        if !day.holes.isEmpty {
            fishingDays.insert(day, at: 0)
        }
        currentDay = nil
        UserDefaults.standard.removeObject(forKey: currentDayKey)
        saveAll()
    }
    
    // MARK: - Statistics
    var todayHoles: Int {
        currentDay?.holesCount ?? 0
    }
    
    var weekHoles: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let todayCount = currentDay?.holesCount ?? 0
        let historyCount = fishingDays.filter { $0.date >= weekAgo }.reduce(0) { $0 + $1.holesCount }
        return todayCount + historyCount
    }
    
    var seasonHoles: Int {
        let range = SeasonHelper.currentSeasonRange(settings: settings)
        let todayCount = currentDay?.holesCount ?? 0
        let historyCount = fishingDays.filter { $0.date >= range.start && $0.date <= range.end }.reduce(0) { $0 + $1.holesCount }
        return todayCount + historyCount
    }
    
    var previousSeasonHoles: Int {
        let range = SeasonHelper.previousSeasonRange(settings: settings)
        return fishingDays.filter { $0.date >= range.start && $0.date <= range.end }.reduce(0) { $0 + $1.holesCount }
    }
    
    var tripCount: Int {
        let range = SeasonHelper.currentSeasonRange(settings: settings)
        var count = fishingDays.filter { $0.date >= range.start && $0.date <= range.end }.count
        if currentDay != nil { count += 1 }
        return count
    }
    
    var avgHolesPerTrip: Double {
        guard tripCount > 0 else { return 0 }
        return Double(seasonHoles) / Double(tripCount)
    }
    
    var recordDay: FishingDay? {
        fishingDays.max(by: { $0.holesCount < $1.holesCount })
    }
    
    var lowestDay: FishingDay? {
        fishingDays.filter { $0.holesCount > 0 }.min(by: { $0.holesCount < $1.holesCount })
    }
    
    func weeklyStats(weeks: Int = 8) -> [(week: Int, holes: Int)] {
        let calendar = Calendar.current
        var result: [(week: Int, holes: Int)] = []
        
        for i in 0..<weeks {
            let weekStart = calendar.date(byAdding: .weekOfYear, value: -i, to: Date())!
            let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
            let weekNum = calendar.component(.weekOfYear, from: weekStart)
            let holes = fishingDays.filter { $0.date >= weekStart && $0.date < weekEnd }.reduce(0) { $0 + $1.holesCount }
            result.append((weekNum, holes))
        }
        
        return result.reversed()
    }
    
    func dayOfWeekStats() -> [(day: String, avgHoles: Double)] {
        let calendar = Calendar.current
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var dayHoles: [Int: [Int]] = [:]
        
        for i in 1...7 {
            dayHoles[i] = []
        }
        
        for day in fishingDays {
            let weekday = calendar.component(.weekday, from: day.date)
            dayHoles[weekday]?.append(day.holesCount)
        }
        
        var result: [(String, Double)] = []
        for i in 1...7 {
            let holes = dayHoles[i] ?? []
            let avg = holes.isEmpty ? 0 : Double(holes.reduce(0, +)) / Double(holes.count)
            result.append((dayNames[i - 1], avg))
        }
        
        return result
    }
    
    var avgDrillingSpeed: Double {
        let validDays = fishingDays.filter { $0.holesPerHour > 0 }
        guard !validDays.isEmpty else { return 0 }
        return validDays.reduce(0) { $0 + $1.holesPerHour } / Double(validDays.count)
    }
    
    var bestDrillingSpeed: (speed: Double, date: Date)? {
        guard let best = fishingDays.filter({ $0.holesPerHour > 0 }).max(by: { $0.holesPerHour < $1.holesPerHour }) else { return nil }
        return (best.holesPerHour, best.date)
    }
    
    // MARK: - Timer
    func startTimer() {
        timerSession = TimerSession()
        save(timerSession!, key: timerSessionKey)
    }
    
    func addTimerHole() {
        guard var session = timerSession else { return }
        session.holes.append(HoleRecord())
        timerSession = session
        save(timerSession!, key: timerSessionKey)
        
        addHole()
    }
    
    func endTimer() {
        guard let session = timerSession else { return }
        
        if var day = currentDay {
            for hole in session.holes {
                if !day.holes.contains(where: { $0.id == hole.id }) {
                    day.holes.append(hole)
                }
            }
            currentDay = day
        }
        
        timerSession = nil
        UserDefaults.standard.removeObject(forKey: timerSessionKey)
        saveAll()
    }
    
    // MARK: - Goals
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveAll()
    }
    
    func updateGoal(_ goal: Goal) {
        if let idx = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[idx] = goal
            saveAll()
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        saveAll()
    }
    
    func goalProgress(_ goal: Goal) -> (current: Int, percentage: Double) {
        var current = 0
        switch goal.goalType {
        case .season:
            current = seasonHoles
        case .month:
            let calendar = Calendar.current
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
            current = fishingDays.filter { $0.date >= monthStart }.reduce(0) { $0 + $1.holesCount }
            current += (currentDay?.holesCount ?? 0)
        case .trip:
            current = recordDay?.holesCount ?? 0
        }
        let pct = goal.targetValue > 0 ? min(100, Double(current) / Double(goal.targetValue) * 100) : 0
        return (current, pct)
    }
    
    // MARK: - Water Bodies
    func addWaterBody(_ body: WaterBody) {
        waterBodies.append(body)
        saveAll()
    }
    
    func updateWaterBody(_ body: WaterBody) {
        if let idx = waterBodies.firstIndex(where: { $0.id == body.id }) {
            waterBodies[idx] = body
            saveAll()
        }
    }
    
    func deleteWaterBody(_ body: WaterBody) {
        waterBodies.removeAll { $0.id == body.id }
        saveAll()
    }
    
    func waterBodyStats(_ bodyId: UUID) -> (visits: Int, totalHoles: Int, avgHoles: Double) {
        let days = fishingDays.filter { $0.waterBodyId == bodyId }
        let visits = days.count
        let total = days.reduce(0) { $0 + $1.holesCount }
        let avg = visits > 0 ? Double(total) / Double(visits) : 0
        return (visits, total, avg)
    }
    
    // MARK: - Day Management
    func updateDay(_ day: FishingDay) {
        if let idx = fishingDays.firstIndex(where: { $0.id == day.id }) {
            fishingDays[idx] = day
            saveAll()
        }
    }
    
    func deleteDay(_ day: FishingDay) {
        fishingDays.removeAll { $0.id == day.id }
        saveAll()
    }
    
    // MARK: - Equipment
    func resetBlades() {
        equipment.bladeUsedHoles = 0
        equipment.lastBladeReplacement = Date()
        saveAll()
    }
    
    func estimatedBladeReplacementDate() -> Date? {
        guard avgHolesPerTrip > 0 && tripCount > 0 else { return nil }
        let daysPerTrip = 7.0
        let holesRemaining = equipment.remainingBladeHoles
        let tripsNeeded = Double(holesRemaining) / avgHolesPerTrip
        let daysNeeded = tripsNeeded * daysPerTrip
        return Calendar.current.date(byAdding: .day, value: Int(daysNeeded), to: Date())
    }
    
    func chargesNeededForTrip() -> Int {
        guard equipment.batteryCapacity > 0 else { return 0 }
        return Int(ceil(avgHolesPerTrip / Double(equipment.batteryCapacity)))
    }
    
    // MARK: - Reset
    func resetAllData() {
        fishingDays = []
        waterBodies = []
        goals = []
        equipment = Equipment()
        currentDay = nil
        timerSession = nil
        
        UserDefaults.standard.removeObject(forKey: daysKey)
        UserDefaults.standard.removeObject(forKey: waterBodiesKey)
        UserDefaults.standard.removeObject(forKey: goalsKey)
        UserDefaults.standard.removeObject(forKey: equipmentKey)
        UserDefaults.standard.removeObject(forKey: currentDayKey)
        UserDefaults.standard.removeObject(forKey: timerSessionKey)
    }
}
