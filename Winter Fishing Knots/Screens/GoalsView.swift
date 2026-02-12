import SwiftUI

// MARK: - Placeholder (reused file slot for KnotDetailView - handled in HistoryView sheet)
// This file provides additional knot illustration shapes used across the app.

struct KnotIllustrationLibrary {
    // All large knot path generators keyed by knot ID
    static func largePath(for knotId: String, in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let cy = h * 0.5

        switch knotId {
        case "improved_clinch":
            p.move(to: CGPoint(x: w * 0.05, y: cy))
            p.addLine(to: CGPoint(x: w * 0.25, y: cy))
            for i in 0..<5 {
                let x = w * (0.28 + CGFloat(i) * 0.08)
                p.addLine(to: CGPoint(x: x, y: i % 2 == 0 ? cy - h * 0.15 : cy + h * 0.15))
            }
            p.addLine(to: CGPoint(x: w * 0.72, y: cy))
            p.addLine(to: CGPoint(x: w * 0.85, y: cy))
            p.addEllipse(in: CGRect(x: w * 0.85, y: cy - 8, width: 16, height: 16))

        case "uni":
            p.move(to: CGPoint(x: w * 0.05, y: cy + h * 0.1))
            p.addLine(to: CGPoint(x: w * 0.3, y: cy + h * 0.1))
            p.addCurve(to: CGPoint(x: w * 0.3, y: cy - h * 0.1),
                       control1: CGPoint(x: w * 0.55, y: cy + h * 0.1),
                       control2: CGPoint(x: w * 0.55, y: cy - h * 0.1))
            p.addLine(to: CGPoint(x: w * 0.85, y: cy - h * 0.1))
            p.addEllipse(in: CGRect(x: w * 0.85, y: cy - h * 0.1 - 8, width: 16, height: 16))

        case "trilene":
            p.move(to: CGPoint(x: w * 0.05, y: cy))
            p.addEllipse(in: CGRect(x: w * 0.2, y: cy - h * 0.15, width: w * 0.2, height: h * 0.15))
            p.addEllipse(in: CGRect(x: w * 0.3, y: cy, width: w * 0.2, height: h * 0.15))
            p.move(to: CGPoint(x: w * 0.5, y: cy))
            p.addLine(to: CGPoint(x: w * 0.85, y: cy))
            p.addEllipse(in: CGRect(x: w * 0.85, y: cy - 8, width: 16, height: 16))

        case "snell":
            let shankX = w * 0.7
            p.move(to: CGPoint(x: shankX, y: h * 0.1))
            p.addLine(to: CGPoint(x: shankX, y: h * 0.9))
            p.addCurve(to: CGPoint(x: shankX - w * 0.15, y: h * 0.7),
                       control1: CGPoint(x: shankX, y: h * 1.0),
                       control2: CGPoint(x: shankX - w * 0.15, y: h * 0.95))
            for i in 0..<6 {
                let y = h * (0.2 + CGFloat(i) * 0.08)
                p.move(to: CGPoint(x: shankX - w * 0.06, y: y))
                p.addLine(to: CGPoint(x: shankX + w * 0.06, y: y + h * 0.04))
            }

        case "blood":
            p.move(to: CGPoint(x: w * 0.05, y: cy - h * 0.05))
            p.addLine(to: CGPoint(x: w * 0.35, y: cy - h * 0.05))
            p.move(to: CGPoint(x: w * 0.95, y: cy + h * 0.05))
            p.addLine(to: CGPoint(x: w * 0.65, y: cy + h * 0.05))
            p.addEllipse(in: CGRect(x: w * 0.35, y: cy - h * 0.15, width: w * 0.3, height: h * 0.3))

        case "double_uni":
            p.move(to: CGPoint(x: w * 0.05, y: cy - h * 0.05))
            p.addLine(to: CGPoint(x: w * 0.95, y: cy - h * 0.05))
            p.move(to: CGPoint(x: w * 0.05, y: cy + h * 0.05))
            p.addLine(to: CGPoint(x: w * 0.95, y: cy + h * 0.05))
            p.addEllipse(in: CGRect(x: w * 0.25, y: cy - h * 0.12, width: w * 0.15, height: h * 0.24))
            p.addEllipse(in: CGRect(x: w * 0.6, y: cy - h * 0.12, width: w * 0.15, height: h * 0.24))

        case "surgeons":
            p.move(to: CGPoint(x: w * 0.05, y: cy))
            p.addCurve(to: CGPoint(x: w * 0.5, y: cy),
                       control1: CGPoint(x: w * 0.2, y: cy - h * 0.3),
                       control2: CGPoint(x: w * 0.35, y: cy + h * 0.3))
            p.addCurve(to: CGPoint(x: w * 0.95, y: cy),
                       control1: CGPoint(x: w * 0.65, y: cy - h * 0.3),
                       control2: CGPoint(x: w * 0.8, y: cy + h * 0.3))

        case "alberto":
            // Leader loop
            p.move(to: CGPoint(x: w * 0.05, y: cy - h * 0.1))
            p.addLine(to: CGPoint(x: w * 0.3, y: cy - h * 0.1))
            p.move(to: CGPoint(x: w * 0.05, y: cy + h * 0.1))
            p.addLine(to: CGPoint(x: w * 0.3, y: cy + h * 0.1))
            // wraps
            for i in 0..<7 {
                let x = w * (0.32 + CGFloat(i) * 0.07)
                p.move(to: CGPoint(x: x, y: cy - h * 0.15))
                p.addLine(to: CGPoint(x: x + w * 0.03, y: cy + h * 0.15))
            }
            p.move(to: CGPoint(x: w * 0.8, y: cy))
            p.addLine(to: CGPoint(x: w * 0.95, y: cy))

        case "fg":
            p.move(to: CGPoint(x: w * 0.05, y: cy))
            p.addLine(to: CGPoint(x: w * 0.95, y: cy))
            for i in 0..<10 {
                let x = w * (0.15 + CGFloat(i) * 0.065)
                let top = i % 2 == 0
                p.move(to: CGPoint(x: x, y: cy - h * 0.12))
                p.addCurve(to: CGPoint(x: x, y: cy + h * 0.12),
                           control1: CGPoint(x: x + (top ? w * 0.03 : -w * 0.03), y: cy - h * 0.05),
                           control2: CGPoint(x: x + (top ? -w * 0.03 : w * 0.03), y: cy + h * 0.05))
            }

        case "dropper_loop":
            p.move(to: CGPoint(x: w * 0.5, y: h * 0.05))
            p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.35))
            p.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.65),
                       control1: CGPoint(x: w * 0.2, y: h * 0.4),
                       control2: CGPoint(x: w * 0.2, y: h * 0.6))
            p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.95))
            // dropper branch
            p.move(to: CGPoint(x: w * 0.5, y: h * 0.5))
            p.addCurve(to: CGPoint(x: w * 0.85, y: h * 0.5),
                       control1: CGPoint(x: w * 0.65, y: h * 0.3),
                       control2: CGPoint(x: w * 0.85, y: h * 0.35))

        case "loop_knot":
            p.move(to: CGPoint(x: w * 0.05, y: cy))
            p.addLine(to: CGPoint(x: w * 0.35, y: cy))
            // wraps
            for i in 0..<3 {
                let x = w * (0.37 + CGFloat(i) * 0.06)
                p.move(to: CGPoint(x: x, y: cy - h * 0.08))
                p.addLine(to: CGPoint(x: x + w * 0.02, y: cy + h * 0.08))
            }
            // loop
            p.move(to: CGPoint(x: w * 0.55, y: cy))
            p.addCurve(to: CGPoint(x: w * 0.55, y: cy),
                       control1: CGPoint(x: w * 0.75, y: cy - h * 0.25),
                       control2: CGPoint(x: w * 0.75, y: cy + h * 0.25))
            p.move(to: CGPoint(x: w * 0.55, y: cy))
            p.addLine(to: CGPoint(x: w * 0.85, y: cy))
            p.addEllipse(in: CGRect(x: w * 0.85, y: cy - 8, width: 16, height: 16))

        default:
            // Generic
            p.move(to: CGPoint(x: w * 0.1, y: cy))
            p.addCurve(to: CGPoint(x: w * 0.9, y: cy),
                       control1: CGPoint(x: w * 0.35, y: cy - h * 0.3),
                       control2: CGPoint(x: w * 0.65, y: cy + h * 0.3))
        }

        return p
    }
}
