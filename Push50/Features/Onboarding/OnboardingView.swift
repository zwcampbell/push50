import SwiftUI

struct OnboardingView: View {
    let appState: AppState
    @State private var goToPlacement = false

    var body: some View {
        NavigationStack {
            ZStack {
                DS.Colors.offWhite.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    VStack(spacing: 16) {
                        // App icon
                        Image("AppIconImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .accessibilityHidden(true)

                        Text("Push 50")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(DS.Colors.black)

                        Text("50 push-ups. 6 weeks.")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(DS.Colors.black)

                        Text("A simple program that gets you there.")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(DS.Colors.mediumGray)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    PrimaryButton(title: "Get Started") {
                        goToPlacement = true
                    }
                    .padding(.horizontal, DS.Layout.horizontalMargin)
                    .padding(.bottom, 40)
                }
            }
            .navigationDestination(isPresented: $goToPlacement) {
                PlacementTestView(appState: appState)
            }
        }
    }
}
