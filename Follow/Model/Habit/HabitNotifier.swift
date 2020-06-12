//
//  HabitNotifier.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import UserNotifications

class HabitNotifier {
    private static let center = UNUserNotificationCenter.current()
    
    func addNotification(for habit: Habit) {
        let content = UNMutableNotificationContent()
        content.title = "\(habit.name)"
        
        var timeComponents = Calendar.current.dateComponents([.day], from: Date(timeIntervalSinceNow: 60*60*24))
        timeComponents.hour = Int.random(in: 12...23)
        timeComponents.minute = Int.random(in: 0...59)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: false)
        let identifier = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        HabitNotifier.center.add(request) { (error) in
            if error != nil { dLog(error!) }
        }
    }
}
