import Foundation

struct ExportService {
    static func rigToText(_ rig: CustomRig) -> String {
        var lines: [String] = []
        lines.append("=== \(rig.name) ===")
        lines.append("Created: \(formatDate(rig.dateCreated))")
        if let used = rig.lastUsed { lines.append("Last Used: \(formatDate(used))") }
        lines.append("Rating: \(rig.rating)/5")
        lines.append("Catches: \(rig.catchCount)")
        lines.append("")
        lines.append("Components:")
        for c in rig.components.sorted(by: { $0.positionIndex < $1.positionIndex }) {
            lines.append("  [\(c.type.rawValue)] \(c.label) - \(c.detail)")
        }
        if !rig.notes.isEmpty {
            lines.append("")
            lines.append("Notes: \(rig.notes)")
        }
        return lines.joined(separator: "\n")
    }

    static func templateToText(_ tmpl: RigTemplate) -> String {
        var lines: [String] = []
        lines.append("=== \(tmpl.name) ===")
        lines.append("Target: \(tmpl.targetSpecies.joined(separator: ", "))")
        lines.append(tmpl.description)
        lines.append("")
        lines.append("Main Line: \(tmpl.mainLineSpec)")
        lines.append("Leader: \(tmpl.leaderSpec)")
        lines.append("")
        lines.append("Components:")
        for c in tmpl.components { lines.append("  [\(c.type.rawValue)] \(c.label) - \(c.detail)") }
        lines.append("")
        lines.append("Recommended Knots: \(tmpl.recommendedKnots.joined(separator: ", "))")
        return lines.joined(separator: "\n")
    }

    private static func formatDate(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.locale = Locale(identifier: "en_US")
        return f.string(from: d)
    }
}
