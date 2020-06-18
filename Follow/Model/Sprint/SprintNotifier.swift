//
//  SprintNotifier.swift
//  Follow
//
//  Created by Hunter Eisler on 6/12/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import UserNotifications

class SprintNotifier {
    private static let center = UNUserNotificationCenter.current()
    
    func addNotification(for sprint: Sprint) {
        let content = UNMutableNotificationContent()
        content.title = sprint.name
        
        var timeComponents = Calendar.current.dateComponents([.day, .hour], from: Date(timeIntervalSinceNow: 60*60*24))
        if timeComponents.hour! < 12 {
            // if the hour is between midnight and noon,
            // set the reminders for today
            timeComponents.day = nil
        }
        timeComponents.hour = Int.random(in: 12...23)
        timeComponents.minute = Int.random(in: 0...59)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: false)
        let identifier = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        SprintNotifier.center.add(request) { (error) in
            if error != nil { dLog(error!) }
        }
    }
}
