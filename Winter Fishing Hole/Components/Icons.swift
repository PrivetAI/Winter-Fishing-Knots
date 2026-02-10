import SwiftUI

// MARK: - Custom Icons using SwiftUI Shapes
struct DrillIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Handle
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: size * 0.3, height: size * 0.35)
                .offset(y: -size * 0.3)
            
            // Motor body
            Capsule()
                .fill(color)
                .frame(width: size * 0.5, height: size * 0.3)
            
            // Auger
            Path { path in
                let centerX = size * 0.5
                let startY = size * 0.15
                let endY = size * 0.5
                let width = size * 0.15
                
                for i in 0..<4 {
                    let y = startY + CGFloat(i) * (endY - startY) / 4
                    path.move(to: CGPoint(x: centerX - width, y: y))
                    path.addLine(to: CGPoint(x: centerX + width, y: y + 5))
                }
                
                path.move(to: CGPoint(x: centerX, y: startY))
                path.addLine(to: CGPoint(x: centerX, y: endY))
            }
            .stroke(color, lineWidth: 2)
            .offset(y: size * 0.25)
        }
        .frame(width: size, height: size)
    }
}

struct HoleIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Ice surface
            Rectangle()
                .fill(Color.white.opacity(0.8))
                .frame(width: size, height: size * 0.3)
                .offset(y: -size * 0.15)
            
            // Hole (ellipse)
            Ellipse()
                .fill(AppTheme.darkBlue)
                .frame(width: size * 0.6, height: size * 0.25)
            
            // Water
            Ellipse()
                .fill(color.opacity(0.7))
                .frame(width: size * 0.5, height: size * 0.18)
                .offset(y: 2)
            
            // Ice border
            Ellipse()
                .stroke(color, lineWidth: 2)
                .frame(width: size * 0.6, height: size * 0.25)
        }
        .frame(width: size, height: size)
    }
}

struct FishIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Body
            Ellipse()
                .fill(color)
                .frame(width: size * 0.7, height: size * 0.35)
            
            // Tail
            Path { path in
                path.move(to: CGPoint(x: size * 0.8, y: size * 0.5))
                path.addLine(to: CGPoint(x: size, y: size * 0.3))
                path.addLine(to: CGPoint(x: size, y: size * 0.7))
                path.closeSubpath()
            }
            .fill(color)
            .offset(x: -size * 0.15)
            
            // Eye
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.1, height: size * 0.1)
                .offset(x: -size * 0.2, y: -size * 0.02)
        }
        .frame(width: size, height: size)
    }
}

struct ChartIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        HStack(alignment: .bottom, spacing: size * 0.08) {
            ForEach([0.4, 0.7, 0.5, 0.9], id: \.self) { h in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: size * 0.15, height: size * CGFloat(h))
            }
        }
        .frame(width: size, height: size)
    }
}

struct GearIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Outer teeth
            ForEach(0..<8) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: size * 0.2, height: size * 0.15)
                    .offset(y: -size * 0.35)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
            
            // Inner circle
            Circle()
                .fill(color)
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Center hole
            Circle()
                .fill(AppTheme.iceBackground)
                .frame(width: size * 0.2, height: size * 0.2)
        }
        .frame(width: size, height: size)
    }
}

struct TimerIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Clock face
            Circle()
                .stroke(color, lineWidth: size * 0.08)
                .frame(width: size * 0.8, height: size * 0.8)
            
            // Hour hand
            RoundedRectangle(cornerRadius: 1)
                .fill(color)
                .frame(width: size * 0.06, height: size * 0.25)
                .offset(y: -size * 0.1)
            
            // Minute hand
            RoundedRectangle(cornerRadius: 1)
                .fill(color)
                .frame(width: size * 0.04, height: size * 0.3)
                .offset(y: -size * 0.12)
                .rotationEffect(.degrees(75))
            
            // Top button
            RoundedRectangle(cornerRadius: 1)
                .fill(color)
                .frame(width: size * 0.1, height: size * 0.15)
                .offset(y: -size * 0.45)
        }
        .frame(width: size, height: size)
    }
}

struct TargetIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: size * 0.06)
                .frame(width: size * 0.9, height: size * 0.9)
            
            Circle()
                .stroke(color, lineWidth: size * 0.06)
                .frame(width: size * 0.55, height: size * 0.55)
            
            Circle()
                .fill(color)
                .frame(width: size * 0.25, height: size * 0.25)
        }
        .frame(width: size, height: size)
    }
}

struct CalendarIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: size * 0.1)
                .fill(color)
                .frame(width: size * 0.85, height: size * 0.75)
                .offset(y: size * 0.05)
            
            // Header
            RoundedRectangle(cornerRadius: size * 0.1)
                .fill(color.opacity(0.8))
                .frame(width: size * 0.85, height: size * 0.25)
                .offset(y: -size * 0.2)
            
            // Rings
            ForEach([-0.2, 0.2], id: \.self) { x in
                RoundedRectangle(cornerRadius: 1)
                    .fill(color)
                    .frame(width: size * 0.08, height: size * 0.2)
                    .offset(x: size * CGFloat(x), y: -size * 0.35)
            }
            
            // Grid dots
            ForEach(0..<2) { row in
                ForEach(0..<3) { col in
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.1, height: size * 0.1)
                        .offset(
                            x: CGFloat(col - 1) * size * 0.22,
                            y: CGFloat(row) * size * 0.2 + size * 0.08
                        )
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct ExportIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Document
            RoundedRectangle(cornerRadius: size * 0.1)
                .stroke(color, lineWidth: size * 0.08)
                .frame(width: size * 0.6, height: size * 0.75)
                .offset(y: size * 0.05)
            
            // Arrow
            Path { path in
                let centerX = size * 0.5
                path.move(to: CGPoint(x: centerX, y: size * 0.6))
                path.addLine(to: CGPoint(x: centerX, y: size * 0.2))
                path.move(to: CGPoint(x: centerX - size * 0.15, y: size * 0.35))
                path.addLine(to: CGPoint(x: centerX, y: size * 0.2))
                path.addLine(to: CGPoint(x: centerX + size * 0.15, y: size * 0.35))
            }
            .stroke(color, lineWidth: size * 0.08)
        }
        .frame(width: size, height: size)
    }
}

struct WaterIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Wave 1
            Path { path in
                path.move(to: CGPoint(x: 0, y: size * 0.4))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: size * 0.4),
                    control: CGPoint(x: size * 0.25, y: size * 0.2)
                )
                path.addQuadCurve(
                    to: CGPoint(x: size, y: size * 0.4),
                    control: CGPoint(x: size * 0.75, y: size * 0.6)
                )
            }
            .stroke(color, lineWidth: size * 0.08)
            
            // Wave 2
            Path { path in
                path.move(to: CGPoint(x: 0, y: size * 0.6))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: size * 0.6),
                    control: CGPoint(x: size * 0.25, y: size * 0.4)
                )
                path.addQuadCurve(
                    to: CGPoint(x: size, y: size * 0.6),
                    control: CGPoint(x: size * 0.75, y: size * 0.8)
                )
            }
            .stroke(color.opacity(0.7), lineWidth: size * 0.08)
        }
        .frame(width: size, height: size)
    }
}

struct PlusIcon: View {
    var size: CGFloat = 24
    var color: Color = .white
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.1)
                .fill(color)
                .frame(width: size * 0.25, height: size * 0.8)
            
            RoundedRectangle(cornerRadius: size * 0.1)
                .fill(color)
                .frame(width: size * 0.8, height: size * 0.25)
        }
        .frame(width: size, height: size)
    }
}

struct HistoryIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Arrow circle
            Circle()
                .trim(from: 0.15, to: 0.85)
                .stroke(color, lineWidth: size * 0.08)
                .frame(width: size * 0.75, height: size * 0.75)
            
            // Arrow head
            Path { path in
                path.move(to: CGPoint(x: size * 0.15, y: size * 0.35))
                path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.2))
                path.addLine(to: CGPoint(x: size * 0.35, y: size * 0.4))
            }
            .stroke(color, lineWidth: size * 0.08)
        }
        .frame(width: size, height: size)
    }
}

struct SettingsIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        GearIcon(size: size, color: color)
    }
}

struct TrashIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.danger
    
    var body: some View {
        ZStack {
            // Lid
            RoundedRectangle(cornerRadius: 1)
                .fill(color)
                .frame(width: size * 0.7, height: size * 0.1)
                .offset(y: -size * 0.35)
            
            // Handle
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: size * 0.25, height: size * 0.1)
                .offset(y: -size * 0.42)
            
            // Body
            Path { path in
                path.move(to: CGPoint(x: size * 0.2, y: size * 0.2))
                path.addLine(to: CGPoint(x: size * 0.25, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.75, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.2))
            }
            .fill(color)
            
            // Lines
            ForEach([0.35, 0.5, 0.65], id: \.self) { x in
                Rectangle()
                    .fill(AppTheme.iceBackground)
                    .frame(width: size * 0.04, height: size * 0.2)
                    .offset(x: size * (CGFloat(x) - 0.5), y: size * 0.1)
            }
        }
        .frame(width: size, height: size)
    }
}

struct EditIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        ZStack {
            // Pencil body
            Path { path in
                path.move(to: CGPoint(x: size * 0.75, y: size * 0.15))
                path.addLine(to: CGPoint(x: size * 0.2, y: size * 0.7))
                path.addLine(to: CGPoint(x: size * 0.1, y: size * 0.9))
                path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.8))
                path.addLine(to: CGPoint(x: size * 0.85, y: size * 0.25))
                path.closeSubpath()
            }
            .fill(color)
        }
        .frame(width: size, height: size)
    }
}

struct CheckIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.success
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: size * 0.2, y: size * 0.5))
            path.addLine(to: CGPoint(x: size * 0.4, y: size * 0.7))
            path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.3))
        }
        .stroke(color, style: StrokeStyle(lineWidth: size * 0.12, lineCap: .round, lineJoin: .round))
        .frame(width: size, height: size)
    }
}

struct ArrowLeftIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: size * 0.6, y: size * 0.2))
            path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.5))
            path.addLine(to: CGPoint(x: size * 0.6, y: size * 0.8))
        }
        .stroke(color, style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round))
        .frame(width: size, height: size)
    }
}

struct MenuIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.primaryBlue
    
    var body: some View {
        VStack(spacing: size * 0.15) {
            ForEach(0..<3) { _ in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: size * 0.7, height: size * 0.12)
            }
        }
        .frame(width: size, height: size)
    }
}
