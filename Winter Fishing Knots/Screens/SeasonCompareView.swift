import SwiftUI

// MARK: - Rig Detail / Diagram View (used for full-screen rig visualization)
struct RigFullDiagramView: View {
    let components: [RigComponent]
    let title: String

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                .foregroundColor(AppTheme.frostWhite)
                .padding(.top, 12)

            GeometryReader { geo in
                ZStack {
                    GridBackground(spacing: 20)

                    let sorted = components.sorted(by: { $0.positionIndex < $1.positionIndex })
                    let step = geo.size.height / CGFloat(max(sorted.count + 1, 2))

                    // Main line
                    Path { path in
                        path.move(to: CGPoint(x: geo.size.width * 0.5, y: 20))
                        path.addLine(to: CGPoint(x: geo.size.width * 0.5, y: geo.size.height - 20))
                    }
                    .stroke(AppTheme.iceBlue.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

                    ForEach(Array(sorted.enumerated()), id: \.element.id) { idx, comp in
                        let y = step * CGFloat(idx + 1)
                        VStack(spacing: 4) {
                            ComponentIconView(type: comp.type, size: 30)
                            Text(comp.label)
                                .font(.system(size: 9, weight: .medium, design: .monospaced))
                                .foregroundColor(AppTheme.frostWhite)
                            Text(comp.detail)
                                .font(.system(size: 7, design: .monospaced))
                                .foregroundColor(AppTheme.iceBlue.opacity(0.7))
                        }
                        .position(x: geo.size.width * 0.5, y: y)
                    }
                }
            }
        }
        .background(AppTheme.deepNavy)
    }
}
