import Foundation

struct WorkoutDay {
    let week: Int
    let day: Int
    let sets: [SetSpec]
    let restSeconds: Int
}

struct SetSpec {
    let label: String
    let reps: Int         // 0 means "max"
    var isMax: Bool { reps == 0 }
    var displayReps: String { isMax ? "max" : "\(reps)" }
}

enum ProgramSchedule {
    static let allWorkouts: [WorkoutDay] = [
        // WEEK 1
        WorkoutDay(week: 1, day: 1, sets: [s(5), s(5), s(4), s(4), max()], restSeconds: 60),
        WorkoutDay(week: 1, day: 2, sets: [s(6), s(6), s(4), s(4), max()], restSeconds: 60),
        WorkoutDay(week: 1, day: 3, sets: [s(6), s(8), s(6), s(6), max()], restSeconds: 60),
        // WEEK 2
        WorkoutDay(week: 2, day: 1, sets: [s(6), s(8), s(6), s(6), max()], restSeconds: 75),
        WorkoutDay(week: 2, day: 2, sets: [s(6), s(8), s(6), s(6), max()], restSeconds: 75),
        WorkoutDay(week: 2, day: 3, sets: [s(8), s(10), s(7), s(7), max()], restSeconds: 75),
        // WEEK 3
        WorkoutDay(week: 3, day: 1, sets: [s(10), s(12), s(7), s(7), max()], restSeconds: 90),
        WorkoutDay(week: 3, day: 2, sets: [s(10), s(12), s(8), s(8), max()], restSeconds: 90),
        WorkoutDay(week: 3, day: 3, sets: [s(11), s(13), s(9), s(9), max()], restSeconds: 90),
        // WEEK 4
        WorkoutDay(week: 4, day: 1, sets: [s(10), s(12), s(7), s(7), max()], restSeconds: 90),
        WorkoutDay(week: 4, day: 2, sets: [s(12), s(14), s(10), s(10), max()], restSeconds: 90),
        WorkoutDay(week: 4, day: 3, sets: [s(14), s(14), s(10), s(10), max()], restSeconds: 90),
        // WEEK 5
        WorkoutDay(week: 5, day: 1, sets: [s(14), s(16), s(12), s(12), max()], restSeconds: 105),
        WorkoutDay(week: 5, day: 2, sets: [s(16), s(17), s(14), s(13), max()], restSeconds: 105),
        WorkoutDay(week: 5, day: 3, sets: [s(18), s(18), s(14), s(14), max()], restSeconds: 105),
        // WEEK 6
        WorkoutDay(week: 6, day: 1, sets: [s(17), s(19), s(15), s(15), max()], restSeconds: 120),
        WorkoutDay(week: 6, day: 2, sets: [s(18), s(20), s(16), s(16), max()], restSeconds: 120),
        WorkoutDay(week: 6, day: 3, sets: [s(20), s(20), s(16), s(15), max()], restSeconds: 120),
    ]

    static func workout(week: Int, day: Int) -> WorkoutDay? {
        allWorkouts.first { $0.week == week && $0.day == day }
    }

    /// Determines starting week from placement test rep count.
    static func startingWeek(forReps reps: Int) -> Int {
        switch reps {
        case 0...4:   return 1
        case 5...9:   return 2
        case 10...14: return 3
        case 15...19: return 4
        default:      return 5
        }
    }

    private static func s(_ reps: Int) -> SetSpec {
        SetSpec(label: "", reps: reps)
    }
    private static func max() -> SetSpec {
        SetSpec(label: "", reps: 0)
    }
}

extension WorkoutDay {
    var labeledSets: [SetSpec] {
        sets.enumerated().map { i, spec in
            SetSpec(label: "Set \(i + 1)", reps: spec.reps)
        }
    }
    var restLabel: String {
        let seconds = restSeconds
        return "\(seconds)s rest between sets"
    }
}
