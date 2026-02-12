import SwiftUI

// MARK: - Custom Shape Icons (NO SF Symbols, NO Emoji)

struct HookIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.55))
        p.addCurve(to: CGPoint(x: w * 0.15, y: h * 0.55),
                   control1: CGPoint(x: w * 0.5, y: h * 0.85),
                   control2: CGPoint(x: w * 0.15, y: h * 0.85))
        p.addLine(to: CGPoint(x: w * 0.15, y: h * 0.35))
        // barb
        p.move(to: CGPoint(x: w * 0.15, y: h * 0.35))
        p.addLine(to: CGPoint(x: w * 0.05, y: h * 0.45))
        return p
    }
}

struct JigIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // jig head (oval)
        p.addEllipse(in: CGRect(x: w * 0.15, y: h * 0.1, width: w * 0.5, height: w * 0.5))
        // hook
        p.move(to: CGPoint(x: w * 0.65, y: h * 0.35))
        p.addCurve(to: CGPoint(x: w * 0.85, y: h * 0.9),
                   control1: CGPoint(x: w * 0.95, y: h * 0.4),
                   control2: CGPoint(x: w * 0.95, y: h * 0.85))
        p.addLine(to: CGPoint(x: w * 0.75, y: h * 0.75))
        return p
    }
}

struct SwivelIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // top ring
        p.addEllipse(in: CGRect(x: w * 0.3, y: 0, width: w * 0.4, height: h * 0.25))
        // body
        p.move(to: CGPoint(x: w * 0.4, y: h * 0.25))
        p.addLine(to: CGPoint(x: w * 0.6, y: h * 0.75))
        p.move(to: CGPoint(x: w * 0.6, y: h * 0.25))
        p.addLine(to: CGPoint(x: w * 0.4, y: h * 0.75))
        // bottom ring
        p.addEllipse(in: CGRect(x: w * 0.3, y: h * 0.75, width: w * 0.4, height: h * 0.25))
        return p
    }
}

struct SinkerIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // teardrop sinker
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addCurve(to: CGPoint(x: w * 0.5, y: h),
                   control1: CGPoint(x: w * 1.0, y: h * 0.3),
                   control2: CGPoint(x: w * 0.8, y: h * 0.9))
        p.addCurve(to: CGPoint(x: w * 0.5, y: 0),
                   control1: CGPoint(x: w * 0.2, y: h * 0.9),
                   control2: CGPoint(x: 0, y: h * 0.3))
        return p
    }
}

struct FloatIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // stem top
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.3))
        // body oval
        p.addEllipse(in: CGRect(x: w * 0.15, y: h * 0.3, width: w * 0.7, height: h * 0.45))
        // stem bottom
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.75))
        p.addLine(to: CGPoint(x: w * 0.5, y: h))
        return p
    }
}

struct LineIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addCurve(to: CGPoint(x: w * 0.5, y: h),
                   control1: CGPoint(x: w * 0.2, y: h * 0.3),
                   control2: CGPoint(x: w * 0.8, y: h * 0.7))
        return p
    }
}

struct KnotSymbolIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let cx = w * 0.5, cy = h * 0.5
        let r = min(w, h) * 0.35
        // figure-eight / infinity knot symbol
        p.move(to: CGPoint(x: cx, y: cy))
        p.addCurve(to: CGPoint(x: cx, y: cy),
                   control1: CGPoint(x: cx - r, y: cy - r),
                   control2: CGPoint(x: cx - r, y: cy + r))
        p.addCurve(to: CGPoint(x: cx, y: cy),
                   control1: CGPoint(x: cx + r, y: cy + r),
                   control2: CGPoint(x: cx + r, y: cy - r))
        return p
    }
}

struct RigBuilderIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // wrench / tool shape
        p.move(to: CGPoint(x: w * 0.2, y: h * 0.8))
        p.addLine(to: CGPoint(x: w * 0.6, y: h * 0.4))
        // gear head
        p.addEllipse(in: CGRect(x: w * 0.5, y: h * 0.1, width: w * 0.35, height: h * 0.35))
        return p
    }
}

struct BookIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // left page
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.05, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.05, y: h * 0.9))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.85))
        // right page
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.95, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.95, y: h * 0.9))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.85))
        // spine
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.85))
        return p
    }
}

struct StarIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX, cy = rect.midY
        let outerR = min(rect.width, rect.height) * 0.48
        let innerR = outerR * 0.4
        for i in 0..<10 {
            let angle = (CGFloat(i) * .pi / 5) - (.pi / 2)
            let r = i % 2 == 0 ? outerR : innerR
            let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

struct CalculatorIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // outer box
        p.addRoundedRect(in: CGRect(x: w * 0.1, y: h * 0.05, width: w * 0.8, height: h * 0.9),
                         cornerSize: CGSize(width: 4, height: 4))
        // display
        p.addRect(CGRect(x: w * 0.2, y: h * 0.15, width: w * 0.6, height: h * 0.2))
        // buttons grid
        for row in 0..<3 {
            for col in 0..<3 {
                let x = w * (0.22 + CGFloat(col) * 0.2)
                let y = h * (0.45 + CGFloat(row) * 0.15)
                p.addEllipse(in: CGRect(x: x, y: y, width: w * 0.12, height: w * 0.12))
            }
        }
        return p
    }
}

struct SpreaderIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // center line
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.4))
        // arms
        p.move(to: CGPoint(x: w * 0.1, y: h * 0.4))
        p.addLine(to: CGPoint(x: w * 0.9, y: h * 0.4))
        // drops
        p.move(to: CGPoint(x: w * 0.1, y: h * 0.4))
        p.addLine(to: CGPoint(x: w * 0.1, y: h))
        p.move(to: CGPoint(x: w * 0.9, y: h * 0.4))
        p.addLine(to: CGPoint(x: w * 0.9, y: h))
        return p
    }
}

struct StopperIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addLine(to: CGPoint(x: w * 0.5, y: h))
        // knot bump
        p.addEllipse(in: CGRect(x: w * 0.25, y: h * 0.35, width: w * 0.5, height: h * 0.3))
        return p
    }
}

struct PlusIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let t = min(w, h) * 0.15
        p.addRect(CGRect(x: (w - t) / 2, y: h * 0.15, width: t, height: h * 0.7))
        p.addRect(CGRect(x: w * 0.15, y: (h - t) / 2, width: w * 0.7, height: t))
        return p
    }
}

struct TrashIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // lid
        p.move(to: CGPoint(x: w * 0.15, y: h * 0.2))
        p.addLine(to: CGPoint(x: w * 0.85, y: h * 0.2))
        // handle
        p.move(to: CGPoint(x: w * 0.35, y: h * 0.2))
        p.addLine(to: CGPoint(x: w * 0.35, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.65, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.65, y: h * 0.2))
        // body
        p.move(to: CGPoint(x: w * 0.2, y: h * 0.25))
        p.addLine(to: CGPoint(x: w * 0.25, y: h * 0.9))
        p.addLine(to: CGPoint(x: w * 0.75, y: h * 0.9))
        p.addLine(to: CGPoint(x: w * 0.8, y: h * 0.25))
        return p
    }
}

struct ChevronRightIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.3, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.7, y: h * 0.5))
        p.addLine(to: CGPoint(x: w * 0.3, y: h * 0.9))
        return p
    }
}

struct GearIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX, cy = rect.midY
        let outerR = min(rect.width, rect.height) * 0.45
        let innerR = outerR * 0.7
        let teeth = 8
        for i in 0..<(teeth * 2) {
            let angle = (CGFloat(i) * .pi / CGFloat(teeth)) - (.pi / 2)
            let r = i % 2 == 0 ? outerR : innerR
            let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        // center hole
        p.addEllipse(in: CGRect(x: cx - outerR * 0.25, y: cy - outerR * 0.25,
                                width: outerR * 0.5, height: outerR * 0.5))
        return p
    }
}

// MARK: - Component icon helper
struct ComponentIconView: View {
    let type: ComponentType
    let size: CGFloat

    var body: some View {
        Group {
            switch type {
            case .hook: HookIcon().stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
            case .jig: JigIcon().stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
            case .sinker: SinkerIcon().stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
            case .swivel: SwivelIcon().stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
            case .float: FloatIcon().stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
            case .mainLine: LineIcon().stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
            case .leader: LineIcon().stroke(AppTheme.warmAccent, lineWidth: AppTheme.medLine)
            case .spreader: SpreaderIcon().stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
            case .stopper: StopperIcon().stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
            }
        }
        .frame(width: size, height: size)
    }
}
