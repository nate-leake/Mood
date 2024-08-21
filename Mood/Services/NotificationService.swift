//
//  NotificationService.swift
//  Mood
//
//  Created by Nate Leake on 8/21/24.
//

import SwiftUI
import UserNotifications

class AppState: ObservableObject {
    @Published var navigateToLogMoodView: Bool = false
}

struct NotificationService: View {
    var body: some View {
        VStack {
            
        }
        .onAppear() {
            checkNotificationSettings()
        }
    }
    
    func checkNotificationSettings() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchLocalNotification()
            case .denied:
                return
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        print("Error requesting authorization: \(error)")
                    } else if granted {
                        self.dispatchLocalNotification()
                    } else {
                        print("Notification permission denied")
                    }
                }
            default: return
            }
        }
    }

    // Function to schedule a local notification
    func dispatchLocalNotification() {
        let center = UNUserNotificationCenter.current()
        let identifier = "daily_log_reminder"
        let content = UNMutableNotificationContent()
        let hour = 19
        let minute = 00
        let isDaily = true
        
        content.title = "Time to log"
        content.body = "You can now log your mood"
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // remove any notifications with the same identifier that is already in the queue
        center.removePendingNotificationRequests(withIdentifiers: [identifier])

        // Schedule the notification
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}
