import SwiftUI

// MARK: - Knot Strength Comparison Chart
struct KnotStrengthChart: View {
    let knots: [FishingKnot]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(knots.sorted(by: { $0.strengthPercent > $1.strengthPercent })) { knot in
                HStack(spacing: 8) {
                    Text(knot.name)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(AppTheme.frostWhite)
                        .frame(width: 120, alignment: .trailing)
                    StrengthBar(percent: knot.strengthPercent)
                    Text("\(knot.strengthPercent)%")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(AppTheme.accent)
                        .frame(width: 35)
                }
            }
        }
    }
}

// MARK: - Line Strength Visual
struct LineStrengthGauge: View {
    let needed: Double
    let maxScale: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppTheme.cardBg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(AppTheme.gridLine, lineWidth: AppTheme.thinLine)
                    )
                // fill
                RoundedRectangle(cornerRadius: 4)
                    .fill(fillColor)
                    .frame(width: max(4, geo.size.width * CGFloat(min(needed / maxScale, 1.0))))
                // markers
                ForEach([0.25, 0.5, 0.75], id: \.self) { frac in
                    Rectangle()
                        .fill(AppTheme.frostWhite.opacity(0.2))
                        .frame(width: 1)
                        .offset(x: geo.size.width * CGFloat(frac))
                }
            }
        }
        .frame(height: 20)
    }

    var fillColor: Color {
        let ratio = needed / maxScale
        if ratio < 0.3 { return AppTheme.success }
        if ratio < 0.6 { return AppTheme.accent }
        if ratio < 0.8 { return AppTheme.warmAccent }
        return AppTheme.danger
    }
}

// MARK: - Rig Catch Counter Bar Chart
struct CatchBarChart: View {
    let rigs: [CustomRig]

    var body: some View {
        let topRigs = Array(rigs.sorted(by: { $0.catchCount > $1.catchCount }).prefix(6))
        let maxCatch = topRigs.first?.catchCount ?? 1

        VStack(alignment: .leading, spacing: 6) {
            ForEach(topRigs) { rig in
                HStack(spacing: 8) {
                    Text(rig.name)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(AppTheme.frostWhite)
                        .frame(width: 100, alignment: .trailing)
                        .lineLimit(1)
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(AppTheme.accent)
                            .frame(width: max(4, geo.size.width * CGFloat(rig.catchCount) / CGFloat(max(maxCatch, 1))))
                    }
                    .frame(height: 12)
                    Text("\(rig.catchCount)")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(AppTheme.warmAccent)
                        .frame(width: 30)
                }
            }
        }
    }
}
