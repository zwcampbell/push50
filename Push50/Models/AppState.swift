import SwiftData
import Foundation

@Model
final class AppState {
    var hasCompletedOnboarding: Bool = false
    var currentWeek: Int = 1          // 1-based
    var currentDay: Int = 1           // 1-based, 1-3 per week
    var streakCount: Int = 0
    var lastWorkoutDate: Date?
    var placementReps: Int = 0
    var reminderEnabled: Bool = false
    var reminderHour: Int = 9
    var reminderMinute: Int = 0

    init() {}

    var isWorkoutDueToday: Bool {
        guard let last = lastWorkoutDate else { return true }
        return !Calendar.current.isDateInToday(last)
    }

    var nextWorkoutLabel: String {
        guard let last = lastWorkoutDate else { return "" }
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: last) ?? last
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return "Next workout: \(formatter.string(from: tomorrow))"
    }

    /// Advances to the next day/week after a completed workout.
    func advanceProgram() {
        lastWorkoutDate = Date()
        streakCount += 1

        if currentDay < 3 {
            currentDay += 1
        } else if currentWeek < 6 {
            currentWeek += 1
            currentDay = 1
        }
        // Week 6 Day 3 completion is the program end — stay here until reset.
    }

    var isProgramComplete: Bool {
        currentWeek == 6 && currentDay == 3 && lastWorkoutDate != nil
    }

    func reset() {
        hasCompletedOnboarding = false
        currentWeek = 1
        currentDay = 1
        streakCount = 0
        lastWorkoutDate = nil
        placementReps = 0
    }
}
