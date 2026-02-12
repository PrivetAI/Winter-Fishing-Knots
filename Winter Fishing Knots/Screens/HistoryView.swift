import SwiftUI

// MARK: - Knot Guide List View
struct KnotListView: View {
    @State private var selectedCategory: KnotCategory?
    @State private var selectedKnot: FishingKnot?

    private var filteredKnots: [FishingKnot] {
        if let cat = selectedCategory {
            return KnotData.allKnots.filter { $0.category == cat }
        }
        return KnotData.allKnots
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                BlueprintSectionHeader(title: "Fishing Knots Guide")

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        categoryButton(nil, label: "All")
                        ForEach(KnotCategory.allCases, id: \.rawValue) { cat in
                            categoryButton(cat, label: cat.rawValue)
                        }
                    }
                }

                // Strength overview
                if selectedKnot == nil {
                    BlueprintCard {
                        Text("Strength Comparison")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.frostWhite)
                            .padding(.bottom, 4)
                        KnotStrengthChart(knots: filteredKnots)
                    }
                }

                // Knot list
                ForEach(filteredKnots) { knot in
                    Button(action: { withAnimation { selectedKnot = knot } }) {
                        knotRow(knot)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Spacer(minLength: 20)
            }
            .padding(16)
        }
        .background(AppTheme.surfaceBg)
        .sheet(item: $selectedKnot) { knot in
            KnotDetailSheet(knot: knot)
        }
    }

    @ViewBuilder
    func categoryButton(_ cat: KnotCategory?, label: String) -> some View {
        Button(action: { selectedCategory = cat }) {
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(selectedCategory == cat ? AppTheme.deepNavy : AppTheme.frostWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(selectedCategory == cat ? AppTheme.accent : AppTheme.cardBg)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(AppTheme.gridLine, lineWidth: AppTheme.thinLine)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    @ViewBuilder
    func knotRow(_ knot: FishingKnot) -> some View {
        BlueprintCard {
            HStack(spacing: 12) {
                // Knot mini illustration
                KnotMiniIllustration(knotId: knot.id)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(knot.name)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.frostWhite)
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Text("Diff:")
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(AppTheme.iceBlue)
                            DifficultyView(knot.difficulty)
                        }
                        HStack(spacing: 4) {
                            Text("Str:")
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(AppTheme.iceBlue)
                            Text("\(knot.strengthPercent)%")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(AppTheme.accent)
                        }
                    }
                    Text(knot.bestUse)
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundColor(AppTheme.iceBlue.opacity(0.7))
                        .lineLimit(2)
                }

                Spacer()

                ChevronRightIcon()
                    .stroke(AppTheme.iceBlue, lineWidth: AppTheme.medLine)
                    .frame(width: 12, height: 12)
            }
        }
    }
}

// MARK: - Knot Mini Illustrations (custom paths)
struct KnotMiniIllustration: View {
    let knotId: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(AppTheme.deepNavy)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(AppTheme.gridLine, lineWidth: AppTheme.thinLine)
                )
            knotShape
                .stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
                .padding(6)
        }
    }

    var knotShape: Path {
        Path { p in
            let s: CGFloat = 32
            switch knotId {
            case "palomar":
                // Loop through eye then overhand
                p.move(to: CGPoint(x: 2, y: s * 0.5))
                p.addCurve(to: CGPoint(x: s - 2, y: s * 0.5),
                           control1: CGPoint(x: s * 0.3, y: 2),
                           control2: CGPoint(x: s * 0.7, y: 2))
                p.addCurve(to: CGPoint(x: 2, y: s * 0.5),
                           control1: CGPoint(x: s * 0.7, y: s - 2),
                           control2: CGPoint(x: s * 0.3, y: s - 2))
            case "improved_clinch":
                // Spiral wraps
                p.move(to: CGPoint(x: 2, y: s * 0.5))
                for i in 0..<5 {
                    let x = 6 + CGFloat(i) * 5
                    p.addLine(to: CGPoint(x: x, y: i % 2 == 0 ? s * 0.3 : s * 0.7))
                }
                p.addLine(to: CGPoint(x: s - 2, y: s * 0.5))
            case "uni":
                p.move(to: CGPoint(x: 2, y: s * 0.7))
                p.addLine(to: CGPoint(x: s * 0.4, y: s * 0.7))
                p.addCurve(to: CGPoint(x: s * 0.4, y: s * 0.3),
                           control1: CGPoint(x: s * 0.7, y: s * 0.7),
                           control2: CGPoint(x: s * 0.7, y: s * 0.3))
                p.addLine(to: CGPoint(x: s - 2, y: s * 0.3))
            case "trilene":
                p.move(to: CGPoint(x: 2, y: s * 0.5))
                p.addEllipse(in: CGRect(x: s * 0.15, y: s * 0.2, width: s * 0.3, height: s * 0.3))
                p.addEllipse(in: CGRect(x: s * 0.25, y: s * 0.35, width: s * 0.3, height: s * 0.3))
                p.move(to: CGPoint(x: s * 0.55, y: s * 0.5))
                p.addLine(to: CGPoint(x: s - 2, y: s * 0.5))
            case "snell":
                p.move(to: CGPoint(x: s * 0.5, y: 2))
                p.addLine(to: CGPoint(x: s * 0.5, y: s - 2))
                for i in 0..<4 {
                    let y = 8 + CGFloat(i) * 5
                    p.move(to: CGPoint(x: s * 0.3, y: y))
                    p.addLine(to: CGPoint(x: s * 0.7, y: y + 3))
                }
            case "blood":
                p.move(to: CGPoint(x: 2, y: s * 0.4))
                p.addLine(to: CGPoint(x: s * 0.5, y: s * 0.4))
                p.move(to: CGPoint(x: s - 2, y: s * 0.6))
                p.addLine(to: CGPoint(x: s * 0.5, y: s * 0.6))
                p.addEllipse(in: CGRect(x: s * 0.35, y: s * 0.3, width: s * 0.3, height: s * 0.4))
            case "double_uni":
                p.move(to: CGPoint(x: 2, y: s * 0.4))
                p.addLine(to: CGPoint(x: s - 2, y: s * 0.4))
                p.move(to: CGPoint(x: 2, y: s * 0.6))
                p.addLine(to: CGPoint(x: s - 2, y: s * 0.6))
                p.addEllipse(in: CGRect(x: s * 0.2, y: s * 0.3, width: s * 0.2, height: s * 0.4))
                p.addEllipse(in: CGRect(x: s * 0.6, y: s * 0.3, width: s * 0.2, height: s * 0.4))
            case "surgeons":
                p.move(to: CGPoint(x: 2, y: s * 0.5))
                p.addCurve(to: CGPoint(x: s - 2, y: s * 0.5),
                           control1: CGPoint(x: s * 0.3, y: s * 0.1),
                           control2: CGPoint(x: s * 0.7, y: s * 0.9))
            case "alberto":
                p.move(to: CGPoint(x: 2, y: s * 0.3))
                for i in 0..<7 {
                    let x = 4 + CGFloat(i) * 4
                    p.addLine(to: CGPoint(x: x, y: i % 2 == 0 ? s * 0.3 : s * 0.7))
                }
                p.addLine(to: CGPoint(x: s - 2, y: s * 0.5))
            case "fg":
                p.move(to: CGPoint(x: 2, y: s * 0.5))
                p.addLine(to: CGPoint(x: s - 2, y: s * 0.5))
                for i in 0..<8 {
                    let x = 4 + CGFloat(i) * 3.5
                    p.move(to: CGPoint(x: x, y: s * 0.3))
                    p.addLine(to: CGPoint(x: x + 1.5, y: s * 0.7))
                }
            case "dropper_loop":
                p.move(to: CGPoint(x: s * 0.5, y: 2))
                p.addLine(to: CGPoint(x: s * 0.5, y: s * 0.35))
                p.addCurve(to: CGPoint(x: s * 0.5, y: s * 0.65),
                           control1: CGPoint(x: s * 0.1, y: s * 0.45),
                           control2: CGPoint(x: s * 0.1, y: s * 0.55))
                p.addLine(to: CGPoint(x: s * 0.5, y: s - 2))
                // Loop branch
                p.move(to: CGPoint(x: s * 0.5, y: s * 0.5))
                p.addCurve(to: CGPoint(x: s * 0.85, y: s * 0.5),
                           control1: CGPoint(x: s * 0.65, y: s * 0.3),
                           control2: CGPoint(x: s * 0.85, y: s * 0.35))
            case "loop_knot":
                p.move(to: CGPoint(x: 2, y: s * 0.5))
                p.addLine(to: CGPoint(x: s * 0.4, y: s * 0.5))
                p.addEllipse(in: CGRect(x: s * 0.4, y: s * 0.25, width: s * 0.35, height: s * 0.5))
                p.move(to: CGPoint(x: s * 0.75, y: s * 0.5))
                p.addLine(to: CGPoint(x: s - 2, y: s * 0.5))
            default:
                p.addEllipse(in: CGRect(x: s * 0.2, y: s * 0.2, width: s * 0.6, height: s * 0.6))
            }
        }
    }
}

// MARK: - Knot Detail Sheet
struct KnotDetailSheet: View {
    let knot: FishingKnot
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header illustration
                    ZStack {
                        GridBackground(spacing: 15)
                        KnotLargeIllustration(knotId: knot.id)
                            .stroke(AppTheme.accent, lineWidth: AppTheme.thickLine)
                            .padding(20)
                    }
                    .frame(height: 180)
                    .background(AppTheme.deepNavy)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .stroke(AppTheme.gridLine, lineWidth: AppTheme.thinLine)
                    )
                    .cornerRadius(AppTheme.cornerRadius)

                    // Stats
                    BlueprintCard {
                        HStack(spacing: 20) {
                            VStack(spacing: 4) {
                                Text("Difficulty")
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundColor(AppTheme.iceBlue)
                                DifficultyView(knot.difficulty)
                            }
                            VStack(spacing: 4) {
                                Text("Strength")
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundColor(AppTheme.iceBlue)
                                Text("\(knot.strengthPercent)%")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundColor(AppTheme.accent)
                            }
                            VStack(spacing: 4) {
                                Text("Category")
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundColor(AppTheme.iceBlue)
                                Text(knot.category.rawValue)
                                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                                    .foregroundColor(AppTheme.frostWhite)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                    // Best use
                    BlueprintCard {
                        Text("Best Use")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        Text(knot.bestUse)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AppTheme.frostWhite)
                            .padding(.top, 2)
                    }

                    // Step by step
                    BlueprintCard {
                        Text("Step-by-Step Instructions")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                            .padding(.bottom, 4)

                        ForEach(Array(knot.steps.enumerated()), id: \.offset) { idx, step in
                            HStack(alignment: .top, spacing: 10) {
                                ZStack {
                                    Circle()
                                        .stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
                                        .frame(width: 22, height: 22)
                                    Text("\(idx + 1)")
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                        .foregroundColor(AppTheme.accent)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(step)
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(AppTheme.frostWhite)
                                        .fixedSize(horizontal: false, vertical: true)

                                    // Step illustration
                                    KnotStepIllustration(knotId: knot.id, step: idx)
                                        .stroke(AppTheme.iceBlue.opacity(0.6), lineWidth: AppTheme.medLine)
                                        .frame(height: 40)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.vertical, 4)

                            if idx < knot.steps.count - 1 {
                                Rectangle()
                                    .fill(AppTheme.gridLine)
                                    .frame(height: 0.5)
                                    .padding(.leading, 32)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(AppTheme.surfaceBg.edgesIgnoringSafeArea(.all))
            .navigationBarTitle(knot.name, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                        .foregroundColor(AppTheme.accent)
                }
            }
        }
        .forcedAppearance()
    }
}

// MARK: - Large Knot Illustration
struct KnotLargeIllustration: Shape {
    let knotId: String

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let cx = w * 0.5, cy = h * 0.5

        switch knotId {
        case "palomar":
            p.move(to: CGPoint(x: w * 0.1, y: cy))
            p.addCurve(to: CGPoint(x: cx, y: h * 0.2),
                       control1: CGPoint(x: w * 0.2, y: cy),
                       control2: CGPoint(x: w * 0.3, y: h * 0.2))
            p.addCurve(to: CGPoint(x: w * 0.9, y: cy),
                       control1: CGPoint(x: w * 0.7, y: h * 0.2),
                       control2: CGPoint(x: w * 0.8, y: cy))
            // Return loop
            p.move(to: CGPoint(x: w * 0.1, y: cy))
            p.addCurve(to: CGPoint(x: cx, y: h * 0.8),
                       control1: CGPoint(x: w * 0.2, y: cy),
                       control2: CGPoint(x: w * 0.3, y: h * 0.8))
            p.addCurve(to: CGPoint(x: w * 0.9, y: cy),
                       control1: CGPoint(x: w * 0.7, y: h * 0.8),
                       control2: CGPoint(x: w * 0.8, y: cy))
            // Hook eye
            p.addEllipse(in: CGRect(x: w * 0.85, y: cy - 8, width: 16, height: 16))
        default:
            // Generic knot shape
            p.move(to: CGPoint(x: w * 0.1, y: cy))
            p.addCurve(to: CGPoint(x: cx, y: cy),
                       control1: CGPoint(x: w * 0.25, y: h * 0.2),
                       control2: CGPoint(x: w * 0.4, y: h * 0.8))
            p.addCurve(to: CGPoint(x: w * 0.9, y: cy),
                       control1: CGPoint(x: w * 0.6, y: h * 0.2),
                       control2: CGPoint(x: w * 0.75, y: h * 0.8))
            p.addEllipse(in: CGRect(x: w * 0.85, y: cy - 8, width: 16, height: 16))
        }
        return p
    }
}

// MARK: - Step Illustration
struct KnotStepIllustration: Shape {
    let knotId: String
    let step: Int

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // Generic step visualization based on step number
        let progress = CGFloat(step + 1) / 6.0
        p.move(to: CGPoint(x: w * 0.1, y: h * 0.5))
        p.addCurve(to: CGPoint(x: w * progress, y: h * 0.5),
                   control1: CGPoint(x: w * 0.2, y: h * 0.2),
                   control2: CGPoint(x: w * progress * 0.7, y: h * 0.8))
        // line continuation
        p.addLine(to: CGPoint(x: w * 0.9, y: h * 0.5))
        return p
    }
}

extension FishingKnot: Equatable {
    static func == (lhs: FishingKnot, rhs: FishingKnot) -> Bool { lhs.id == rhs.id }
}
