import SwiftUI

struct PrimaryButton: View {
    let title: String
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(enabled ? DS.Colors.white : DS.Colors.lightGray)
                .frame(maxWidth: .infinity)
                .frame(height: DS.Layout.buttonHeight)
                .background(enabled ? DS.Colors.superRed : DS.Colors.dividerGray)
                .clipShape(RoundedRectangle(cornerRadius: DS.Layout.cornerRadius))
        }
        .disabled(!enabled)
        .buttonStyle(.plain)
    }
}
