import SwiftUI

struct MainTabView: View {
    let appState: AppState
    @State private var selectedTab: NavTab = .today
    @State private var showWorkout = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .today:
                    HomeView(appState: appState, showWorkout: $showWorkout)
                case .progress:
                    ProgressView(appState: appState)
                case .settings:
                    SettingsView(appState: appState)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            BottomNavBar(selected: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $showWorkout) {
            if let workout = ProgramSchedule.workout(week: appState.currentWeek, day: appState.currentDay) {
                WorkoutView(appState: appState, workout: workout, isPresented: $showWorkout)
            }
        }
    }
}
