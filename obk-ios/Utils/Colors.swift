import UIKit

public enum Color: String {
    case black
    case green
    case lightGray
    case orange
    case red
    
    public static let allColors: [Color] = [
        .black, .green, .lightGray, .orange, .red
    ]
}

public extension Color {
    public func uiColor() -> UIColor {
        switch self {
        case .black:          return .hex(0x000000)
        case .green:          return .hex(0x4cd957)
        case .lightGray:      return .hex(0xe0e0e0)
        case .orange:         return .hex(0xf38748)
        case .red:            return .hex(0xf34848)
        }
    }
}
