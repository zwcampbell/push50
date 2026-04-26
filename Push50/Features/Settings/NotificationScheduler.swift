import UserNotifications

enum NotificationScheduler {
    private static let identifier = "push50.daily-reminder"

    static func requestAndSchedule(appState: AppState) {
        let hour = appState.reminderHour
        let minute = appState.reminderMinute
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                schedule(hour: hour, minute: minute)
            }
        }
    }

    static func reschedule(appState: AppState) {
        cancel()
        guard appState.reminderEnabled else { return }
        schedule(hour: appState.reminderHour, minute: appState.reminderMinute)
    }

    static func cancel() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    private static func schedule(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to push 💪"
        content.body = "Your workout is ready. Keep the streak going."
        content.sound = .default

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
