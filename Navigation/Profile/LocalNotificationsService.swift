//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Евгений Дроздов on 16.05.2023.
//

import UIKit
import UserNotifications

struct LocalNotificationsService {
    static func registeForLatestUpdatesIfPossible() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .badge, .provisional]) { result, error in
            
            if let error = error { print("Что-то пошло не так, текст ошибки: ", error) }
            
            if result == true {
                
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = "Посмотрите последние уведомления"
                    content.body = "Что-то новое в твоей ленте"
                    content.sound = .default
                    content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber
                    
                    var component = DateComponents()
                    component.hour = 19
                    component.minute = 00
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    center.add(request)
                }
            }
        }
    }
}
