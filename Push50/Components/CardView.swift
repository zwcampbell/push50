import SwiftUI

struct CardView<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(DS.Layout.cardPadding)
            .background(DS.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: DS.Layout.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: DS.Layout.cornerRadius)
                    .stroke(DS.Colors.dividerGray, lineWidth: 1)
            )
    }
}
