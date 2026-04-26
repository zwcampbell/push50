import SwiftUI

struct HomeView: View {
    let appState: AppState
    @Binding var showWorkout: Bool

    private var workout: WorkoutDay? {
        ProgramSchedule.workout(week: appState.currentWeek, day: appState.currentDay)
    }

    private var dayNumber: Int {
        (appState.currentWeek - 1) * 3 + appState.currentDay
    }

    var body: some View {
        ZStack {
            DS.Colors.offWhite.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, DS.Layout.horizontalMargin)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                ScrollView {
                    VStack(spacing: 16) {
                        if let workout {
                            WorkoutCard(
                                workout: workout,
                                onStart: { showWorkout = true }
                            )
                            .padding(.horizontal, DS.Layout.horizontalMargin)
                        }

                        if !appState.isWorkoutDueToday {
                            Text(appState.nextWorkoutLabel)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(DS.Colors.lightGray)
                        } else if appState.currentDay == 1 || appState.currentDay == 3 {
                            Text("Rest day tomorrow")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(DS.Colors.lightGray)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, DS.Layout.bottomNavHeight + 16)
                }
            }
        }
    }

    private var topBar: some View {
        HStack {
            Text("Week \(appState.currentWeek) · Day \(dayNumber)")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(DS.Colors.mediumGray)

            Spacer()

            StreakBadge(count: appState.streakCount)
        }
    }
}

// MARK: - Workout Card

struct WorkoutCard: View {
    let workout: WorkoutDay
    let onStart: () -> Void

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 0) {
                Text("TODAY")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(DS.Colors.superRed)
                    .padding(.bottom, 12)

                ForEach(Array(workout.labeledSets.enumerated()), id: \.offset) { i, set in
                    VStack(spacing: 0) {
                        if i > 0 {
                            Divider()
                                .foregroundStyle(DS.Colors.dividerGray)
                                .padding(.vertical, 10)
                        }
                        HStack {
                            Text(set.label)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(DS.Colors.black)
                            Spacer()
                            Text(set.displayReps)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(DS.Colors.black)
                        }
                    }
                }

                Text(workout.restLabel)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(DS.Colors.mediumGray)
                    .padding(.top, 16)

                PrimaryButton(title: "Start Workout", action: onStart)
                    .padding(.top, 16)
            }
        }
    }
}
