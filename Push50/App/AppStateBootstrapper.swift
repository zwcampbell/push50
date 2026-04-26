import SwiftUI
import SwiftData

/// Inserts the singleton AppState on first launch, then hands off to RootView.
struct AppStateBootstrapper: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        Color(DS.Colors.offWhite)
            .ignoresSafeArea()
            .onAppear {
                let state = AppState()
                context.insert(state)
            }
    }
}
