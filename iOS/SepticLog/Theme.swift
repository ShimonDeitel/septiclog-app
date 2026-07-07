import SwiftUI

/// earthy brown with a muted sage accent
enum Theme {
    static let primary = Color(red: 0.294, green: 0.251, blue: 0.196)
    static let accent = Color(red: 0.561, green: 0.682, blue: 0.447)
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headingFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
}
