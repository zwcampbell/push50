import SwiftUI

struct StreakBadge: View {
    let count: Int

    var body: some View {
        Text("🔥 \(count)")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(DS.Colors.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(DS.Colors.superRed)
            .clipShape(Capsule())
    }
}
