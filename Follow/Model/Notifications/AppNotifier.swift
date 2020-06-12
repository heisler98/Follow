//
//  AppNotifier.swift
//  Follow
//
//  Created by Hunter Eisler on 6/12/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import UserNotifications

///Type for handling general, non-specific notifications.
class AppNotifier {
    static let morningNotificationIdentifierKey = "kFollowMorningNotificationIdentifier"
    static let nightNotificationIdentifierKey = "kFollowNightNotificationIdentifier"
    static let notificationsAllowedKey = "kFollowGeneralNotificationsAllowed"
    
    private static let center = UNUserNotificationCenter.current()
    
    var morningNotificationIdentifier: String?
    var nightNotificationIdentifier: String?
    
    var setupComplete: Bool {
        if let value = UserDefaults.standard.value(forKey: AppNotifier.notificationsAllowedKey) as? Int, value == 0 {
            return true
        }
        return (morningNotificationIdentifier != nil && nightNotificationIdentifier != nil)
    }
    
    func setMorningNotifications() {
        guard morningNotificationIdentifier == nil else { return }
        morningNotificationIdentifier = UUID().uuidString
        
        let content = UNMutableNotificationContent()
        content.title = "Good morning"
        var timeComponents = Calendar.current.dateComponents([.day], from: Date(timeIntervalSinceNow: 60*60*24))
        timeComponents.hour = 12
        timeComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
        let request = UNNotificationRequest(identifier: morningNotificationIdentifier!, content: content, trigger: trigger)
        AppNotifier.center.add(request) { (error) in
            if error != nil { dLog(error!); return }
            UserDefaults.standard.set(self.morningNotificationIdentifier, forKey: AppNotifier.morningNotificationIdentifierKey)
        }
    }
    
    func setNightNotifications() {
        guard nightNotificationIdentifier == nil else { return }
        nightNotificationIdentifier = UUID().uuidString
        
        let content = UNMutableNotificationContent()
        content.title = "Follow tomorrow"
        var timeComponents = Calendar.current.dateComponents([.day], from: Date(timeIntervalSinceNow: 60*60*24))
        timeComponents.hour = 22
        timeComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
        let request = UNNotificationRequest(identifier: nightNotificationIdentifier!, content: content, trigger: trigger)
        AppNotifier.center.add(request) { (error) in
            if error != nil { dLog(error!); return }
            UserDefaults.standard.set(self.nightNotificationIdentifier, forKey: AppNotifier.nightNotificationIdentifierKey)
        }
        
    }
    
    func removeMorningNotifications() {
        guard morningNotificationIdentifier != nil else { return }
        AppNotifier.center.removePendingNotificationRequests(withIdentifiers: [morningNotificationIdentifier!])
    }
    
    func removeNightNotifications() {
        guard nightNotificationIdentifier != nil else { return }
        AppNotifier.center.removePendingNotificationRequests(withIdentifiers: [nightNotificationIdentifier!])
    }
    
    
    func stopNotifications() {
        UserDefaults.standard.set(0, forKey: AppNotifier.notificationsAllowedKey)
    }
    
    init() {
        morningNotificationIdentifier = UserDefaults.standard.string(forKey: AppNotifier.morningNotificationIdentifierKey)
        nightNotificationIdentifier = UserDefaults.standard.string(forKey: AppNotifier.nightNotificationIdentifierKey)
    }
    
}
