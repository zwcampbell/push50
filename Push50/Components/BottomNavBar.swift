import SwiftUI

enum NavTab: String, CaseIterable {
    case today    = "Today"
    case progress = "Progress"
    case settings = "Settings"

    var icon: String {
        switch self {
        case .today:    "house.fill"
        case .progress: "chart.line.uptrend.xyaxis"
        case .settings: "gearshape.fill"
        }
    }
}

struct BottomNavBar: View {
    @Binding var selected: NavTab

    var body: some View {
        VStack(spacing: 0) {
            Divider().foregroundStyle(DS.Colors.dividerGray)
            HStack(spacing: 0) {
                ForEach(NavTab.allCases, id: \.self) { tab in
                    Button {
                        selected = tab
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 22))
                            Text(tab.rawValue)
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundStyle(selected == tab ? DS.Colors.superRed : DS.Colors.lightGray)
                        .frame(maxWidth: .infinity)
                        .frame(height: DS.Layout.bottomNavHeight)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(tab.rawValue)
                    .accessibilityAddTraits(selected == tab ? .isSelected : [])
                }
            }
            .background(DS.Colors.white)
        }
    }
}
