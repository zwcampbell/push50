import SwiftUI

struct SettingsView: View {
    let appState: AppState
    @State private var showResetConfirmation = false
    @Environment(\.modelContext) private var context
    @Environment(\.openURL) private var openURL

    private var reminderTime: Binding<Date> {
        Binding {
            Calendar.current.date(
                bySettingHour: appState.reminderHour,
                minute: appState.reminderMinute,
                second: 0,
                of: Date()
            ) ?? Date()
        } set: { date in
            let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
            appState.reminderHour = comps.hour ?? 9
            appState.reminderMinute = comps.minute ?? 0
            NotificationScheduler.reschedule(appState: appState)
        }
    }

    var body: some View {
        ZStack {
            DS.Colors.offWhite.ignoresSafeArea()

            List {
                // MARK: Notifications
                Section {
                    Toggle(isOn: Binding(
                        get: { appState.reminderEnabled },
                        set: { enabled in
                            appState.reminderEnabled = enabled
                            if enabled {
                                NotificationScheduler.requestAndSchedule(appState: appState)
                            } else {
                                NotificationScheduler.cancel()
                            }
                        }
                    )) {
                        Text("Daily Reminder")
                            .foregroundStyle(DS.Colors.black)
                    }
                    .tint(DS.Colors.superRed)

                    if appState.reminderEnabled {
                        DatePicker(
                            "Reminder Time",
                            selection: reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .tint(DS.Colors.superRed)
                    }
                } header: {
                    sectionHeader("Notifications")
                }
                .listRowBackground(DS.Colors.white)

                // MARK: Program
                Section {
                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        Text("Reset Program")
                            .foregroundStyle(DS.Colors.superRed)
                    }
                } header: {
                    sectionHeader("Program")
                }
                .listRowBackground(DS.Colors.white)

                // MARK: Support
                Section {
                    NavigationLink {
                        // Rate stub — opens App Store in production
                    } label: {
                        Text("Rate Push 50")
                            .foregroundStyle(DS.Colors.black)
                    }

                    NavigationLink {
                        AboutView()
                    } label: {
                        Text("About")
                            .foregroundStyle(DS.Colors.black)
                    }
                } header: {
                    sectionHeader("Support")
                }
                .listRowBackground(DS.Colors.white)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
        .confirmationDialog(
            "Reset Program",
            isPresented: $showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset", role: .destructive) {
                appState.reset()
                NotificationScheduler.cancel()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will erase all progress and return you to Week 1. This cannot be undone.")
        }
        .navigationBarTitleDisplayMode(.large)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(DS.Colors.mediumGray)
            .textCase(.uppercase)
    }
}

struct AboutView: View {
    var body: some View {
        ZStack {
            DS.Colors.offWhite.ignoresSafeArea()
            VStack(spacing: 8) {
                Text("Push 50")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(DS.Colors.black)
                Text("Version 1.0")
                    .font(.system(size: 15))
                    .foregroundStyle(DS.Colors.mediumGray)
            }
        }
    }
}
