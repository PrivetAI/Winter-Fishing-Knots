import SwiftUI

// MARK: - Rig Diagram Shapes (additional visual components for rig drawings)
struct RigConnectionLine: Shape {
    let startY: CGFloat
    let endY: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: startY))
        p.addLine(to: CGPoint(x: rect.midX, y: endY))
        return p
    }
}

struct RigNodeMarker: Shape {
    let centerY: CGFloat
    let nodeType: ComponentType

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX
        let r: CGFloat = 6

        switch nodeType {
        case .hook:
            p.move(to: CGPoint(x: cx, y: centerY - r))
            p.addLine(to: CGPoint(x: cx, y: centerY + r))
            p.addCurve(to: CGPoint(x: cx - r, y: centerY),
                       control1: CGPoint(x: cx, y: centerY + r * 1.5),
                       control2: CGPoint(x: cx - r, y: centerY + r * 1.2))
        case .swivel:
            p.addEllipse(in: CGRect(x: cx - r * 0.6, y: centerY - r, width: r * 1.2, height: r))
            p.addEllipse(in: CGRect(x: cx - r * 0.6, y: centerY, width: r * 1.2, height: r))
        case .sinker:
            p.move(to: CGPoint(x: cx, y: centerY - r))
            p.addCurve(to: CGPoint(x: cx, y: centerY + r),
                       control1: CGPoint(x: cx + r, y: centerY),
                       control2: CGPoint(x: cx + r * 0.5, y: centerY + r))
            p.addCurve(to: CGPoint(x: cx, y: centerY - r),
                       control1: CGPoint(x: cx - r * 0.5, y: centerY + r),
                       control2: CGPoint(x: cx - r, y: centerY))
        default:
            p.addEllipse(in: CGRect(x: cx - r, y: centerY - r, width: r * 2, height: r * 2))
        }
        return p
    }
}

// MARK: - Rig Assembly Preview (used in builder and library)
struct RigAssemblyPreview: View {
    let components: [RigComponent]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let sorted = components.sorted(by: { $0.positionIndex < $1.positionIndex })
            let count = max(sorted.count, 1)
            let step = h / CGFloat(count + 1)

            ZStack {
                // Connection line
                Path { path in
                    path.move(to: CGPoint(x: w * 0.5, y: 4))
                    path.addLine(to: CGPoint(x: w * 0.5, y: h - 4))
                }
                .stroke(AppTheme.iceBlue.opacity(0.3), style: StrokeStyle(lineWidth: 0.8, dash: [3, 2]))

                ForEach(Array(sorted.enumerated()), id: \.element.id) { idx, comp in
                    let y = step * CGFloat(idx + 1)
                    RigNodeMarker(centerY: y, nodeType: comp.type)
                        .stroke(AppTheme.accent, lineWidth: AppTheme.medLine)

                    // Label to the right
                    Text(comp.label)
                        .font(.system(size: 7, design: .monospaced))
                        .foregroundColor(AppTheme.iceBlue)
                        .position(x: w * 0.75, y: y)
                }
            }
        }
    }
}
