import SwiftUI

// MARK: - Rig Library View
struct RigLibraryView: View {
    @State private var selectedTemplate: RigTemplate?

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                BlueprintSectionHeader(title: "Ice Fishing Rig Library")

                ForEach(RigData.allTemplates) { tmpl in
                    Button(action: { selectedTemplate = tmpl }) {
                        rigCard(tmpl)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Spacer(minLength: 20)
            }
            .padding(16)
        }
        .background(AppTheme.surfaceBg)
        .sheet(item: $selectedTemplate) { tmpl in
            RigTemplateDetailSheet(template: tmpl)
        }
    }

    @ViewBuilder
    func rigCard(_ tmpl: RigTemplate) -> some View {
        BlueprintCard {
            HStack(spacing: 12) {
                // Mini diagram
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppTheme.deepNavy)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(AppTheme.gridLine, lineWidth: AppTheme.thinLine)
                        )
                    TemplateMinDiagram(components: tmpl.components)
                        .stroke(AppTheme.accent, lineWidth: AppTheme.medLine)
                        .padding(4)
                }
                .frame(width: 50, height: 60)

                VStack(alignment: .leading, spacing: 4) {
                    Text(tmpl.name)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.frostWhite)
                    Text(tmpl.targetSpecies.joined(separator: ", "))
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(AppTheme.warmAccent)
                    Text(tmpl.description)
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

// MARK: - Template Mini Diagram
struct TemplateMinDiagram: Shape {
    let components: [RigComponent]

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let count = max(components.count, 1)
        let step = h / CGFloat(count + 1)

        // Main line
        p.move(to: CGPoint(x: w * 0.5, y: 2))
        p.addLine(to: CGPoint(x: w * 0.5, y: h - 2))

        // Component nodes
        for i in 0..<components.count {
            let y = step * CGFloat(i + 1)
            let nodeSize: CGFloat = 5
            p.addEllipse(in: CGRect(x: w * 0.5 - nodeSize, y: y - nodeSize,
                                    width: nodeSize * 2, height: nodeSize * 2))
        }
        return p
    }
}

// MARK: - Rig Template Detail Sheet
struct RigTemplateDetailSheet: View {
    let template: RigTemplate
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Full diagram
                    ZStack {
                        GridBackground(spacing: 15)
                        TemplateLargeDiagram(components: template.components)
                            .stroke(AppTheme.accent, lineWidth: AppTheme.thickLine)
                            .padding(20)
                    }
                    .frame(height: CGFloat(template.components.count) * 65 + 60)
                    .background(AppTheme.deepNavy)
                    .cornerRadius(AppTheme.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .stroke(AppTheme.gridLine, lineWidth: AppTheme.thinLine)
                    )

                    // Species
                    BlueprintCard {
                        Text("Target Species")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        HStack(spacing: 8) {
                            ForEach(template.targetSpecies, id: \.self) { sp in
                                Text(sp)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(AppTheme.frostWhite)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(AppTheme.accent, lineWidth: AppTheme.thinLine)
                                    )
                            }
                        }
                        .padding(.top, 4)
                    }

                    // Description
                    BlueprintCard {
                        Text("Description")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        Text(template.description)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AppTheme.frostWhite)
                            .padding(.top, 2)
                    }

                    // Line specs
                    BlueprintCard {
                        Text("Line Specifications")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                        specRow("Main Line", template.mainLineSpec)
                        specRow("Leader", template.leaderSpec)
                    }

                    // Components
                    BlueprintCard {
                        Text("Components")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                            .padding(.bottom, 4)

                        ForEach(template.components) { comp in
                            HStack(spacing: 8) {
                                ComponentIconView(type: comp.type, size: 20)
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(comp.label)
                                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                                        .foregroundColor(AppTheme.frostWhite)
                                    Text(comp.detail)
                                        .font(.system(size: 9, design: .monospaced))
                                        .foregroundColor(AppTheme.iceBlue)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 3)
                        }
                    }

                    // Recommended knots
                    BlueprintCard {
                        Text("Recommended Knots")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.warmAccent)
                            .padding(.bottom, 4)

                        ForEach(template.recommendedKnots, id: \.self) { knotId in
                            if let knot = KnotData.allKnots.first(where: { $0.id == knotId }) {
                                HStack(spacing: 8) {
                                    KnotMiniIllustration(knotId: knotId)
                                        .frame(width: 30, height: 30)
                                    Text(knot.name)
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(AppTheme.frostWhite)
                                    Spacer()
                                    Text("\(knot.strengthPercent)%")
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                        .foregroundColor(AppTheme.accent)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(AppTheme.surfaceBg.edgesIgnoringSafeArea(.all))
            .navigationBarTitle(template.name, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                        .foregroundColor(AppTheme.accent)
                }
            }
        }
        .forcedAppearance()
    }

    @ViewBuilder
    func specRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(AppTheme.iceBlue)
            Spacer()
            Text(value)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(AppTheme.frostWhite)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Large Template Diagram
struct TemplateLargeDiagram: Shape {
    let components: [RigComponent]

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let sorted = components.sorted(by: { $0.positionIndex < $1.positionIndex })
        let count = max(sorted.count, 1)
        let step = h / CGFloat(count + 1)

        // Main line
        p.move(to: CGPoint(x: w * 0.5, y: 5))
        p.addLine(to: CGPoint(x: w * 0.5, y: h - 5))

        for i in 0..<sorted.count {
            let y = step * CGFloat(i + 1)
            let comp = sorted[i]
            switch comp.type {
            case .hook:
                p.move(to: CGPoint(x: w * 0.5, y: y))
                p.addCurve(to: CGPoint(x: w * 0.35, y: y),
                           control1: CGPoint(x: w * 0.5, y: y + 20),
                           control2: CGPoint(x: w * 0.35, y: y + 20))
                p.addLine(to: CGPoint(x: w * 0.35, y: y - 8))
                p.addLine(to: CGPoint(x: w * 0.3, y: y))
            case .jig:
                p.addEllipse(in: CGRect(x: w * 0.4, y: y - 8, width: w * 0.2, height: 16))
                p.move(to: CGPoint(x: w * 0.6, y: y))
                p.addCurve(to: CGPoint(x: w * 0.7, y: y + 15),
                           control1: CGPoint(x: w * 0.75, y: y),
                           control2: CGPoint(x: w * 0.75, y: y + 15))
            case .sinker:
                p.move(to: CGPoint(x: w * 0.5, y: y - 10))
                p.addCurve(to: CGPoint(x: w * 0.5, y: y + 10),
                           control1: CGPoint(x: w * 0.6, y: y - 5),
                           control2: CGPoint(x: w * 0.6, y: y + 5))
                p.addCurve(to: CGPoint(x: w * 0.5, y: y - 10),
                           control1: CGPoint(x: w * 0.4, y: y + 5),
                           control2: CGPoint(x: w * 0.4, y: y - 5))
            case .swivel:
                p.addEllipse(in: CGRect(x: w * 0.45, y: y - 10, width: w * 0.1, height: 8))
                p.move(to: CGPoint(x: w * 0.47, y: y - 2))
                p.addLine(to: CGPoint(x: w * 0.53, y: y + 2))
                p.addEllipse(in: CGRect(x: w * 0.45, y: y + 2, width: w * 0.1, height: 8))
            case .float:
                p.addEllipse(in: CGRect(x: w * 0.42, y: y - 8, width: w * 0.16, height: 16))
                p.move(to: CGPoint(x: w * 0.5, y: y - 12))
                p.addLine(to: CGPoint(x: w * 0.5, y: y - 8))
            case .spreader:
                p.move(to: CGPoint(x: w * 0.25, y: y))
                p.addLine(to: CGPoint(x: w * 0.75, y: y))
                p.move(to: CGPoint(x: w * 0.25, y: y))
                p.addLine(to: CGPoint(x: w * 0.25, y: y + 15))
                p.move(to: CGPoint(x: w * 0.75, y: y))
                p.addLine(to: CGPoint(x: w * 0.75, y: y + 15))
            default:
                // connection dot
                p.addEllipse(in: CGRect(x: w * 0.5 - 4, y: y - 4, width: 8, height: 8))
            }
        }
        return p
    }
}

extension RigTemplate: Equatable {
    static func == (lhs: RigTemplate, rhs: RigTemplate) -> Bool { lhs.id == rhs.id }
}
