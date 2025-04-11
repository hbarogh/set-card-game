import SwiftUI

struct SetSymbol: View {
    let shape: SetCardContent.ShapeType
    let shading: SetCardContent.Shading
    let color: SetCardContent.ColorType
    
    var body: some View {
        switch shape {
        case .diamond:
            applyShading(to: DiamondShape())
        case .rectangle:
            applyShading(to: RoundedRectangle(cornerRadius: 6))
        case .oval:
            applyShading(to: Capsule())
        }
    }
    
    private var colorValue: Color {
        switch color{
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
    
    @ViewBuilder
    private func applyShading(to shape: some Shape) -> some View {
        switch shading {
        case .solid:
            shape.fill(colorValue)
        case .striped:
            shape.fill(Color.clear)
                .background(
                    Stripes()
                        .stroke(colorValue, lineWidth: 1)
                        .mask(shape.fill(Color.white))
                )
        case .open:
            shape.stroke(colorValue, lineWidth: 2)
        }
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct Stripes: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let stripeSpacing: CGFloat = 6
        for x in stride(from: 0, through: rect.width, by: stripeSpacing){
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
        return path
    }
}
