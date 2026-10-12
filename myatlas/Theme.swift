import SwiftUI

enum MyAtlasTheme {
    static let ink = Color(red: 0.08, green: 0.12, blue: 0.11)
    static let paper = Color(red: 0.95, green: 0.94, blue: 0.88)
    static let moss = Color(red: 0.27, green: 0.39, blue: 0.25)
    static let clay = Color(red: 0.74, green: 0.37, blue: 0.24)
    static let mist = Color(red: 0.83, green: 0.86, blue: 0.81)
}

struct SectionHeading: View {
    let title: String
    let action: String?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(MyAtlasTheme.moss)
            Spacer()
            if let action {
                Text(action)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(MyAtlasTheme.clay)
            }
        }
    }
}