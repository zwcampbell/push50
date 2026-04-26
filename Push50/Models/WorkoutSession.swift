import SwiftData
import Foundation

@Model
final class WorkoutSession {
    var date: Date
    var week: Int
    var day: Int
    var repsPerSet: [Int]
    var durationSeconds: Int

    init(week: Int, day: Int, repsPerSet: [Int], durationSeconds: Int) {
        self.date = Date()
        self.week = week
        self.day = day
        self.repsPerSet = repsPerSet
        self.durationSeconds = durationSeconds
    }

    var totalReps: Int { repsPerSet.reduce(0, +) }

    /// The final set rep count — used for the "Best Max Set" stat and progress chart.
    var maxSetReps: Int { repsPerSet.last ?? 0 }
}
