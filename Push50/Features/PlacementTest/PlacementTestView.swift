import SwiftUI

struct PlacementTestView: View {
    let appState: AppState

    @State private var repsText = ""
    @State private var showResult = false
    @State private var startingWeek = 1
    @FocusState private var inputFocused: Bool

    private var reps: Int { Int(repsText) ?? 0 }
    private var hasInput: Bool { !repsText.isEmpty }

    var body: some View {
        ZStack {
            DS.Colors.offWhite.ignoresSafeArea()

            if showResult {
                resultState
            } else {
                inputState
            }
        }
        .navigationBarBackButtonHidden(showResult)
    }

    // MARK: - Input State

    private var inputState: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Let's find your starting point")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(DS.Colors.black)
                    .multilineTextAlignment(.center)

                Text("Do as many push-ups as you can right now. Enter your count below.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(DS.Colors.mediumGray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, DS.Layout.horizontalMargin)
            .padding(.top, 48)

            Spacer()

            VStack(spacing: 8) {
                TextField("0", text: $repsText)
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(DS.Colors.black)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .focused($inputFocused)
                    .frame(width: 160)
                    .padding(.vertical, 16)
                    .background(DS.Colors.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Layout.cornerRadius)
                            .stroke(DS.Colors.dividerGray, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: DS.Layout.cornerRadius))
                    .onChange(of: repsText) { _, new in
                        // Allow only digits
                        repsText = new.filter { $0.isNumber }
                    }
                    .accessibilityLabel("Push-up count")

                Text("0 is fine — everyone starts somewhere")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(DS.Colors.lightGray)
            }

            Spacer()

            PrimaryButton(title: "Find My Week", enabled: hasInput) {
                inputFocused = false
                let week = ProgramSchedule.startingWeek(forReps: reps)
                startingWeek = week
                withAnimation(.easeInOut(duration: 0.3)) {
                    showResult = true
                }
            }
            .padding(.horizontal, DS.Layout.horizontalMargin)
            .padding(.bottom, 40)
        }
        .onAppear { inputFocused = true }
    }

    // MARK: - Result State

    private var resultState: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(DS.Colors.superRed)
                    .accessibilityHidden(true)

                Text("You're starting at Week \(startingWeek)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(DS.Colors.black)
                    .multilineTextAlignment(.center)

                Text("Your first workout is ready.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(DS.Colors.mediumGray)
            }
            .padding(.horizontal, DS.Layout.horizontalMargin)

            Spacer()

            PrimaryButton(title: "Let's Go") {
                appState.placementReps = reps
                appState.currentWeek = startingWeek
                appState.currentDay = 1
                appState.hasCompletedOnboarding = true
            }
            .padding(.horizontal, DS.Layout.horizontalMargin)
            .padding(.bottom, 40)
        }
    }
}
