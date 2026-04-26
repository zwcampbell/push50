import SwiftUI

/// Design system tokens for Push 50.
enum DS {
    enum Colors {
        static let superRed    = Color(hex: "#FF3347")
        static let hoverRed    = Color(hex: "#D9182B")
        static let black       = Color(hex: "#181A1D")
        static let offBlack    = Color(hex: "#222529")
        static let mediumGray  = Color(hex: "#777A81")
        static let lightGray   = Color(hex: "#A8ACB1")
        static let dividerGray = Color(hex: "#E4E6E7")
        static let offWhite    = Color(hex: "#F5F7F9")
        static let white       = Color(hex: "#FFFFFF")
    }

    enum Typography {
        static func largeTitle(_ text: String) -> some View {
            Text(text).font(.system(size: 32, weight: .bold))
        }
        static func title1(_ text: String) -> some View {
            Text(text).font(.system(size: 28, weight: .bold))
        }
        static func title2(_ text: String) -> some View {
            Text(text).font(.system(size: 24, weight: .bold))
        }
        static func headline(_ text: String) -> some View {
            Text(text).font(.system(size: 17, weight: .semibold))
        }
        static func body(_ text: String) -> some View {
            Text(text).font(.system(size: 17, weight: .regular))
        }
        static func subhead(_ text: String) -> some View {
            Text(text).font(.system(size: 15, weight: .regular))
        }
        static func caption(_ text: String) -> some View {
            Text(text).font(.system(size: 14, weight: .regular))
        }
        static func micro(_ text: String) -> some View {
            Text(text).font(.system(size: 13, weight: .regular))
        }
        static func label(_ text: String) -> some View {
            Text(text).font(.system(size: 11, weight: .bold))
        }
        static func numericLarge(_ text: String) -> some View {
            Text(text).font(.system(size: 64, weight: .bold))
        }
        static func numericHuge(_ text: String) -> some View {
            Text(text).font(.system(size: 96, weight: .bold))
        }
    }

    enum Layout {
        static let horizontalMargin: CGFloat = 20
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 54
        static let bottomNavHeight: CGFloat = 83
        static let cardPadding: CGFloat = 20
    }
}

// MARK: - Color hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
