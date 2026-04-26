import SwiftUI
import SwiftData

struct WorkoutView: View {
    let appState: AppState
    let workout: WorkoutDay
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var context

    @State private var vm: WorkoutViewModel

    init(appState: AppState, workout: WorkoutDay, isPresented: Binding<Bool>) {
        self.appState = appState
        self.workout = workout
        self._isPresented = isPresented
        self._vm = State(initialValue: WorkoutViewModel(workout: workout))
    }

    var body: some View {
        ZStack {
            DS.Colors.black.ignoresSafeArea()

            switch vm.phase {
            case .activeSet:
                activeSetView
            case .restTimer:
                restTimerView
            case .maxSetInput:
                MaxSetInputView(vm: vm)
            case .complete:
                completionView
            }
        }
        .confirmationDialog(
            "Exit Workout?",
            isPresented: Binding(
                get: { vm.showExitConfirmation },
                set: { _ in vm.cancelExit() }
            ),
            titleVisibility: .visible
        ) {
            Button("Exit", role: .destructive) { isPresented = false }
            Button("Keep Going", role: .cancel) { vm.cancelExit() }
        } message: {
            Text("Your progress won't be saved.")
        }
    }

    // MARK: - Active Set

    private var activeSetView: some View {
        VStack(spacing: 0) {
            topBar

            Spacer()

            if let set = vm.currentSet {
                VStack(spacing: 4) {
                    Text(set.isMax ? "max" : "\(set.reps)")
                        .font(.system(size: 96, weight: .bold))
                        .foregroundStyle(DS.Colors.white)
                        .accessibilityLabel("\(set.isMax ? "max reps" : "\(set.reps) reps")")

                    Text("reps")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(DS.Colors.lightGray)
                }
            }

            Spacer()

            VStack(spacing: 20) {
                PrimaryButton(title: "Set Complete") {
                    vm.setComplete()
                }
                .padding(.horizontal, DS.Layout.horizontalMargin)

                queueList
            }
            .padding(.bottom, 40)
        }
    }

    private var queueList: some View {
        VStack(spacing: 8) {
            ForEach(Array(vm.queueSets.enumerated()), id: \.offset) { _, set in
                Text("\(set.label) — \(set.displayReps) reps")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(DS.Colors.mediumGray)
            }
        }
    }

    // MARK: - Rest Timer

    private var restTimerView: some View {
        VStack(spacing: 0) {
            topBar

            Spacer()

            ZStack {
                Circle()
                    .stroke(DS.Colors.offBlack, lineWidth: 8)
                    .frame(width: 200, height: 200)

                Circle()
                    .trim(from: 0, to: restProgress)
                    .stroke(DS.Colors.superRed, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: restProgress)

                VStack(spacing: 4) {
                    Text(restTimeFormatted)
                        .font(.system(size: 64, weight: .bold))
                        .foregroundStyle(DS.Colors.white)
                        .monospacedDigit()

                    Text("Rest")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(DS.Colors.lightGray)
                }
            }
            .accessibilityLabel("Rest timer, \(restTimeFormatted) remaining")

            Spacer()

            Button("Skip Rest") {
                vm.skipRest()
            }
            .font(.system(size: 15, weight: .regular))
            .foregroundStyle(DS.Colors.lightGray)
            .padding(.bottom, 60)
        }
    }

    private var restProgress: Double {
        let total = Double(workout.restSeconds)
        let remaining = Double(vm.restSecondsRemaining)
        return total > 0 ? remaining / total : 0
    }

    private var restTimeFormatted: String {
        let s = vm.restSecondsRemaining
        return String(format: "%d:%02d", s / 60, s % 60)
    }

    // MARK: - Completion

    private var completionView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(DS.Colors.superRed)
                    .accessibilityHidden(true)

                Text("Workout Complete 💪")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(DS.Colors.white)

                let setCount = vm.workout.sets.count
                Text("\(setCount) sets done. See you tomorrow.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(DS.Colors.mediumGray)
            }

            Spacer()

            PrimaryButton(title: "Back to Home") {
                saveSession()
                appState.advanceProgram()
                isPresented = false
            }
            .padding(.horizontal, DS.Layout.horizontalMargin)
            .padding(.bottom, 40)
        }
        .onAppear { saveSession() }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {
                vm.requestExit()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(DS.Colors.mediumGray)
            }
            .accessibilityLabel("Exit workout")

            Spacer()

            Text("Set \(vm.currentSetIndex + 1) of \(vm.totalSets)")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(DS.Colors.mediumGray)

            Spacer()

            // Balance the X button
            Color.clear.frame(width: 22, height: 22)
        }
        .padding(.horizontal, DS.Layout.horizontalMargin)
        .padding(.top, 16)
    }

    // MARK: - Save

    @State private var sessionSaved = false

    private func saveSession() {
        guard !sessionSaved else { return }
        let session = WorkoutSession(
            week: workout.week,
            day: workout.day,
            repsPerSet: vm.completedReps,
            durationSeconds: vm.durationSeconds
        )
        context.insert(session)
        sessionSaved = true
    }
}

// MARK: - Max Set Input

struct MaxSetInputView: View {
    let vm: WorkoutViewModel
    @State private var repsText = ""
    @FocusState private var focused: Bool

    private var reps: Int { Int(repsText) ?? 0 }
    private var hasInput: Bool { !repsText.isEmpty && reps > 0 }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                Text("How many did you do?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(DS.Colors.white)

                Text("Enter your max set rep count")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(DS.Colors.mediumGray)

                TextField("0", text: $repsText)
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(DS.Colors.white)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .focused($focused)
                    .frame(width: 160)
                    .padding(.vertical, 16)
                    .background(DS.Colors.offBlack)
                    .clipShape(RoundedRectangle(cornerRadius: DS.Layout.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Layout.cornerRadius)
                            .stroke(DS.Colors.mediumGray, lineWidth: 1)
                    )
                    .onChange(of: repsText) { _, new in
                        repsText = new.filter { $0.isNumber }
                    }
                    .accessibilityLabel("Max set rep count")
            }
            .padding(.horizontal, DS.Layout.horizontalMargin)

            Spacer()

            PrimaryButton(title: "Done", enabled: hasInput) {
                vm.submitMaxReps(reps)
            }
            .padding(.horizontal, DS.Layout.horizontalMargin)
            .padding(.bottom, 40)
        }
        .onAppear { focused = true }
    }
}
