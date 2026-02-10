import Foundation
import SwiftUI

class ExportService {
    static let shared = ExportService()
    
    func generateCSV() -> String {
        let dataService = DataService.shared
        var csv = "Winter Fishing Hole - Data Export\n"
        csv += "Generated: \(formatDate(Date()))\n\n"
        
        // Summary
        csv += "=== SEASON SUMMARY ===\n"
        csv += "Total Holes This Season,\(dataService.seasonHoles)\n"
        csv += "Number of Trips,\(dataService.tripCount)\n"
        csv += "Average Holes Per Trip,\(String(format: "%.1f", dataService.avgHolesPerTrip))\n"
        csv += "Average Drilling Speed (holes/hour),\(String(format: "%.1f", dataService.avgDrillingSpeed))\n\n"
        
        // Daily data
        csv += "=== DAILY DATA ===\n"
        csv += "Date,Holes,Start Time,End Time,Duration,Holes/Hour,Water Body,Notes\n"
        
        for day in dataService.fishingDays.sorted(by: { $0.date > $1.date }) {
            let date = formatDate(day.date)
            let holes = day.holesCount
            let start = day.startTime != nil ? formatTime(day.startTime!) : ""
            let end = day.endTime != nil ? formatTime(day.endTime!) : ""
            let duration = day.durationString
            let speed = String(format: "%.1f", day.holesPerHour)
            let waterBody = dataService.waterBodies.first(where: { $0.id == day.waterBodyId })?.name ?? ""
            let notes = day.notes.replacingOccurrences(of: ",", with: ";").replacingOccurrences(of: "\n", with: " ")
            
            csv += "\(date),\(holes),\(start),\(end),\(duration),\(speed),\(waterBody),\(notes)\n"
        }
        
        csv += "\n=== HOLE TIMESTAMPS ===\n"
        for day in dataService.fishingDays.sorted(by: { $0.date > $1.date }) {
            if !day.holes.isEmpty {
                csv += "\n\(formatDate(day.date)):\n"
                for (idx, hole) in day.holes.enumerated() {
                    csv += "Hole \(idx + 1),\(formatTime(hole.timestamp))\n"
                }
            }
        }
        
        // Goals
        csv += "\n=== GOALS ===\n"
        csv += "Title,Type,Target,Progress\n"
        for goal in dataService.goals {
            let progress = dataService.goalProgress(goal)
            csv += "\(goal.title),\(goal.goalType.rawValue),\(goal.targetValue),\(progress.current)\n"
        }
        
        // Equipment
        csv += "\n=== EQUIPMENT ===\n"
        csv += "Blade Capacity,\(dataService.equipment.bladeCapacity)\n"
        csv += "Holes on Current Blades,\(dataService.equipment.bladeUsedHoles)\n"
        csv += "Blade Wear %,\(String(format: "%.1f", dataService.equipment.bladeWearPercentage))\n"
        csv += "Battery Capacity (holes),\(dataService.equipment.batteryCapacity)\n"
        
        // Water Bodies
        csv += "\n=== WATER BODIES ===\n"
        csv += "Name,Visits,Total Holes,Avg Holes\n"
        for body in dataService.waterBodies {
            let stats = dataService.waterBodyStats(body.id)
            csv += "\(body.name),\(stats.visits),\(stats.totalHoles),\(String(format: "%.1f", stats.avgHoles))\n"
        }
        
        return csv
    }
    
    func getExportFileURL() -> URL {
        let fileName = "WinterFishingHole_\(formatDateForFile(Date())).csv"
        let tempDir = FileManager.default.temporaryDirectory
        return tempDir.appendingPathComponent(fileName)
    }
    
    func writeCSVToFile() -> URL? {
        let csv = generateCSV()
        let url = getExportFileURL()
        
        do {
            try csv.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            return nil
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func formatDateForFile(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
