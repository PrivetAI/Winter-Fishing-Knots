import SwiftUI

// MARK: - Rig Builder View
struct RigBuilderView: View {
    @ObservedObject var dataService: DataService
    @State private var components: [RigComponent] = []
    @State private var rigName: String = ""
    @State private var notes: String = ""
    @State private var showSaveSheet = false
    @State private var selectedComponentType: ComponentType = .mainLine

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Title
                BlueprintSectionHeader(title: "Assemble Your Rig")

                // Component Picker
                BlueprintCard {
                    Text("Add Component")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.frostWhite)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(ComponentType.allCases, id: \.rawValue) { cType in
                                Button(action: { addComponent(cType) }) {
                                    VStack(spacing: 4) {
                                        ComponentIconView(type: cType, size: 28)
                                        Text(cType.rawValue)
                                            .font(.system(size: 8, design: .monospaced))
                                            .foregroundColor(AppTheme.frostWhite)
                                    }
                                    .frame(width: 65, height: 55)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(AppTheme.gridLine, lineWidth: AppTheme.thinLine)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.top, 6)
                }

                // Assembled Rig Diagram
                BlueprintCard {
                    Text("Rig Diagram")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.frostWhite)

                    if components.isEmpty {
                        Text("Tap components above to build your rig")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(AppTheme.iceBlue.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                    } else {
                        RigDiagramCanvas(components: components)
                            .frame(height: max(200, CGFloat(components.count) * 55))
                    }
                }

                // Component List (reorderable)
                if !components.isEmpty {
                    BlueprintCard {
                        HStack {
                            Text("Components (\(components.count))")
                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                .foregroundColor(AppTheme.frostWhite)
                            Spacer()
                            Button(action: { components.removeAll() }) {
                                Text("Clear")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(AppTheme.danger)
                            }
                        }

                        ForEach(Array(components.enumerated()), id: \.element.id) { idx, comp in
                            HStack(spacing: 8) {
                                Text("\(idx + 1)")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(AppTheme.accent)
                                    .frame(width: 20)
                                ComponentIconView(type: comp.type, size: 20)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(comp.label)
                                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                                        .foregroundColor(AppTheme.frostWhite)
                                    Text(comp.detail)
                                        .font(.system(size: 9, design: .monospaced))
                                        .foregroundColor(AppTheme.iceBlue)
                                }
                                Spacer()
                                Button(action: { removeComponent(at: idx) }) {
                                    TrashIcon()
                                        .stroke(AppTheme.danger, lineWidth: AppTheme.medLine)
                                        .frame(width: 16, height: 16)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.vertical, 4)
                            if idx < components.count - 1 {
                                Rectangle()
                                    .fill(AppTheme.gridLine)
                                    .frame(height: 0.5)
                            }
                        }
                    }

                    // Save Button
                    Button(action: { showSaveSheet = true }) {
                        HStack {
                            PlusIcon()
                                .fill(AppTheme.deepNavy)
                                .frame(width: 14, height: 14)
                            Text("Save Custom Rig")
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        }
                        .foregroundColor(AppTheme.deepNavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .fill(AppTheme.accent)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(16)
        }
        .background(AppTheme.surfaceBg)
        .sheet(isPresented: $showSaveSheet) {
            SaveRigSheet(components: components, dataService: dataService) {
                components.removeAll()
                showSaveSheet = false
            }
        }
    }

    private func addComponent(_ type: ComponentType) {
        HapticService.light()
        let comp = RigComponent(
            id: UUID().uuidString,
            type: type,
            label: type.rawValue,
            detail: defaultDetail(for: type),
            positionIndex: components.count
        )
        components.append(comp)
    }

    private func removeComponent(at index: Int) {
        HapticService.light()
        components.remove(at: index)
        for i in 0..<components.count {
            components[i].positionIndex = i
        }
    }

    private func defaultDetail(for type: ComponentType) -> String {
        switch type {
        case .mainLine: return "6lb Braided"
        case .leader: return "4lb Fluorocarbon, 24in"
        case .hook: return "#4 Octopus"
        case .jig: return "1/8oz Tungsten"
        case .sinker: return "1/4oz Split Shot"
        case .swivel: return "#7 Barrel"
        case .float: return "Small Slip Float"
        case .stopper: return "Rubber Stopper"
        case .spreader: return "Wire Spreader Arm"
        }
    }
}

// MARK: - Rig Diagram Canvas (Custom Drawn)
struct RigDiagramCanvas: View {
    let components: [RigComponent]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let sorted = components.sorted(by: { $0.positionIndex < $1.positionIndex })
            let step = h / CGFloat(max(sorted.count + 1, 2))

            ZStack {
                // Main line
                Path { path in
                    path.move(to: CGPoint(x: w * 0.5, y: 10))
                    path.addLine(to: CGPoint(x: w * 0.5, y: h - 10))
                }
                .stroke(AppTheme.iceBlue.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))

                // Components
                ForEach(Array(sorted.enumerated()), id: \.element.id) { idx, comp in
                    let y = step * CGFloat(idx + 1)
                    componentNode(comp, at: CGPoint(x: w * 0.5, y: y), width: w)
                }
            }
        }
    }

    @ViewBuilder
    func componentNode(_ comp: RigComponent, at center: CGPoint, width: CGFloat) -> some View {
        let nodeW: CGFloat = 36
        VStack(spacing: 2) {
            ComponentIconView(type: comp.type, size: nodeW)
            Text(comp.label)
                .font(.system(size: 8, weight: .medium, design: .monospaced))
                .foregroundColor(AppTheme.frostWhite)
            Text(comp.detail)
                .font(.system(size: 7, design: .monospaced))
                .foregroundColor(AppTheme.iceBlue.opacity(0.7))
        }
        .position(x: center.x, y: center.y)
    }
}
