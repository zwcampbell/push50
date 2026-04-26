import SwiftUI
import SwiftData

struct RootView: View {
    @Query private var states: [AppState]

    private var appState: AppState? { states.first }

    var body: some View {
        if let state = appState {
            if state.hasCompletedOnboarding {
                MainTabView(appState: state)
            } else {
                OnboardingView(appState: state)
            }
        } else {
            AppStateBootstrapper()
        }
    }
}
