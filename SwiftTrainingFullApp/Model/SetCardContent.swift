import Foundation

struct SetCardContent: Equatable {
    
    let number: Int
    let shape: ShapeType
    let shading: Shading
    let color: ColorType
    
    enum ShapeType: CaseIterable {
       case diamond, rectangle, oval
    }
    
    enum Shading: CaseIterable {
        case solid, striped, open
    }
    
    enum ColorType: CaseIterable {
        case red, green, purple
    }
}
