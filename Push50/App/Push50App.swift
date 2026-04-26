import SwiftUI
import SwiftData

@main
struct Push50App: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: [AppState.self, WorkoutSession.self])
        }
    }
}
