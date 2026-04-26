import SwiftUI
import Combine
import AVFoundation

@Observable
final class WorkoutViewModel {
    enum Phase {
        case activeSet
        case restTimer
        case maxSetInput
        case complete
    }

    let workout: WorkoutDay
    private(set) var currentSetIndex: Int = 0
    private(set) var phase: Phase = .activeSet
    private(set) var restSecondsRemaining: Int = 0
    private(set) var completedReps: [Int] = []
    private(set) var maxSetReps: Int = 0
    private(set) var workoutStartDate = Date()
    private(set) var showExitConfirmation = false

    private var timerCancellable: AnyCancellable?
    private var audioPlayer: AVAudioPlayer?

    init(workout: WorkoutDay) {
        self.workout = workout
    }

    var currentSet: SetSpec? {
        guard currentSetIndex < workout.sets.count else { return nil }
        return workout.labeledSets[currentSetIndex]
    }

    var totalSets: Int { workout.sets.count }

    var queueSets: [SetSpec] {
        guard currentSetIndex + 1 < workout.sets.count else { return [] }
        return Array(workout.labeledSets[(currentSetIndex + 1)...])
    }

    var durationSeconds: Int {
        Int(Date().timeIntervalSince(workoutStartDate))
    }

    func setComplete() {
        guard let set = currentSet else { return }

        if set.isMax {
            phase = .maxSetInput
        } else {
            completedReps.append(set.reps)
            advanceAfterSet()
        }
    }

    func submitMaxReps(_ reps: Int) {
        maxSetReps = reps
        completedReps.append(reps)
        advanceAfterSet()
    }

    private func advanceAfterSet() {
        let nextIndex = currentSetIndex + 1
        if nextIndex >= workout.sets.count {
            phase = .complete
        } else {
            currentSetIndex = nextIndex
            restSecondsRemaining = workout.restSeconds
            phase = .restTimer
            startRestTimer()
        }
    }

    func skipRest() {
        stopRestTimer()
        phase = .activeSet
    }

    private func startRestTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.restSecondsRemaining > 1 {
                    self.restSecondsRemaining -= 1
                } else {
                    self.restSecondsRemaining = 0
                    self.stopRestTimer()
                    self.fireRestEndFeedback()
                    self.phase = .activeSet
                }
            }
    }

    private func stopRestTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func fireRestEndFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        playChime()
    }

    private func playChime() {
        // Uses the system Tink sound; replace with a bundled asset for custom audio.
        AudioServicesPlaySystemSound(1057)
    }

    func requestExit() {
        showExitConfirmation = true
    }

    func cancelExit() {
        showExitConfirmation = false
    }

    deinit {
        stopRestTimer()
    }
}

// AVFoundation import shim for AudioServicesPlaySystemSound
import AudioToolbox
