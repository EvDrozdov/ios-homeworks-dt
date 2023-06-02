//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Евгений Дроздов on 16.05.2023.
//

import UIKit
import UserNotifications
class LocalNotificationsService {
    let center = UNUserNotificationCenter.current()

    func registeForLatestUpdatesIfPossible() {
        center.requestAuthorization(options: [.sound, .badge, .provisional]) { (success, error) in
            if error != nil {
                print("ERROR: \(String(describing: error))")
            }
            if success {
                self.notificationTimeInterval(hour: 19, minute: 00, repeats: true)

            }
        }
    }

    private func notificationTimeInterval(hour: Int, minute: Int, repeats: Bool) {
        let content = UNMutableNotificationContent()
        DispatchQueue.main.async {
            content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        }
        content.sound = .default
        content.title = "Уведомление"
        content.body = "Посмотрите последние обновления"
        var dateMatching = DateComponents()
        dateMatching.hour = hour
        dateMatching.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: repeats)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        self.center.add(request)
    }
}
