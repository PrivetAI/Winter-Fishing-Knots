import SwiftUI

// MARK: - Line Calculator View
struct LineCalculatorView: View {
    @State private var selectedSpeciesIndex = 0
    @State private var waterClarity: Double = 0.5 // 0=murky, 1=clear
    @State private var depth: Double = 15.0 // feet
    @State private var temperature: Double = 32.0 // F

    private var species: FishSpecies {
        SpeciesData.allSpecies[selectedSpeciesIndex]
    }

    private var recommendedMainLine: Double {
        var base = species.recommendedLineLb
        // Adjust for clarity: clearer = lighter line
        base -= (waterClarity - 0.5) * 2
        // Adjust for depth: deeper = slightly heavier
        base += (depth - 15) * 0.05
        return max(1, min(base, 50))
    }

    private var recommendedLeader: String {
        let len = species.recommendedLeaderLengthIn + (waterClarity * 12) - 6
        let lb = max(1, recommendedMainLine - 1)
        return String(format: "%.0flb Fluoro, %.0f inches", lb, max(6, len))
    }

    private var breakingStrengthNeeded: Double {
        // rough: 1.5x average weight, adjusted for conditions
        let base = species.avgWeightLbs * 1.5
        let coldFactor = temperature < 32 ? 1.2 : 1.0 // cold = stiffer line
        return base * coldFactor
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                BlueprintSectionHeader(title: "Line Calculator")

                // Species picker
                BlueprintCard {
                    Text("Target Species")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.warmAccent)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(SpeciesData.allSpecies.enumerated()), id: \.element.id) { idx, sp in
                                Button(action: { selectedSpeciesIndex = idx }) {
                                    Text(sp.name)
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundColor(idx == selectedSpeciesIndex ? AppTheme.deepNavy : AppTheme.frostWhite)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(idx == selectedSpeciesIndex ? AppTheme.accent : AppTheme.deepNavy)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(AppTheme.gridLine, lineWidth: AppTheme.thinLine)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.top, 4)
                }

                // Species info
                BlueprintCard {
                    Text("Species Profile: \(species.name)")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.frostWhite)
                    HStack(spacing: 16) {
                        infoCell("Avg Weight", String(format: "%.1f lb", species.avgWeightLbs))
                        infoCell("Max Weight", String(format: "%.0f lb", species.maxWeightLbs))
                        infoCell("Habitat", species.habitat)
                    }
                    .padding(.top, 4)
                }

                // Conditions
                BlueprintCard {
                    Text("Conditions")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.warmAccent)

                    VStack(spacing: 12) {
                        sliderRow("Water Clarity", value: $waterClarity, range: 0...1,
                                  labels: ("Murky", "Clear"))
                        sliderRow("Depth (ft)", value: $depth, range: 3...80,
                                  labels: ("3", "80"))
                        sliderRow("Temp (F)", value: $temperature, range: 20...50,
                                  labels: ("20", "50"))
                    }
                    .padding(.top, 6)
                }

                // Results
                BlueprintCard {
                    Text("Recommendations")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.warmAccent)

                    VStack(spacing: 10) {
                        resultRow("Main Line", String(format: "%.0f lb test", recommendedMainLine))

                        Text("Leader")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(AppTheme.iceBlue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(recommendedLeader)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(AppTheme.frostWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Divider().background(AppTheme.gridLine)

                        Text("Breaking Strength Needed")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(AppTheme.iceBlue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        LineStrengthGauge(needed: breakingStrengthNeeded, maxScale: 20)
                        Text(String(format: "%.1f lb minimum", breakingStrengthNeeded))
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(AppTheme.accent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, 6)
                }

                // Quick reference
                BlueprintCard {
                    Text("Quick Reference")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundColor(AppTheme.warmAccent)
                        .padding(.bottom, 4)

                    VStack(spacing: 4) {
                        refRow("Ice Thickness <4in", "Stay Off")
                        refRow("4-5in", "Walk Only")
                        refRow("5-7in", "Snowmobile/ATV")
                        refRow("8-12in", "Light Vehicle")
                        refRow(">12in", "Medium Truck")
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(16)
        }
        .background(AppTheme.surfaceBg)
    }

    @ViewBuilder
    func infoCell(_ label: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 8, design: .monospaced))
                .foregroundColor(AppTheme.iceBlue)
            Text(value)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(AppTheme.frostWhite)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }

    @ViewBuilder
    func sliderRow(_ label: String, value: Binding<Double>, range: ClosedRange<Double>,
                   labels: (String, String)) -> some View {
        VStack(spacing: 2) {
            HStack {
                Text(label)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(AppTheme.frostWhite)
                Spacer()
                Text(String(format: "%.1f", value.wrappedValue))
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(AppTheme.accent)
            }
            Slider(value: value, in: range)
                .accentColor(AppTheme.accent)
            HStack {
                Text(labels.0)
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundColor(AppTheme.iceBlue.opacity(0.5))
                Spacer()
                Text(labels.1)
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundColor(AppTheme.iceBlue.opacity(0.5))
            }
        }
    }

    @ViewBuilder
    func resultRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(AppTheme.iceBlue)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(AppTheme.frostWhite)
        }
    }

    @ViewBuilder
    func refRow(_ condition: String, _ advice: String) -> some View {
        HStack {
            Text(condition)
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(AppTheme.frostWhite)
            Spacer()
            Text(advice)
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundColor(condition.contains("<4") ? AppTheme.danger : AppTheme.iceBlue)
        }
    }
}
