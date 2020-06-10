//
//  HabitTaskScheduler.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import BackgroundTasks

class HabitTaskScheduler {
    
    func register() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.eisler.Follow.refreshNotifications", using: DispatchQueue.global(qos: .background)) { (task) in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.eisler.Follow.refreshNotifications")
        //Fetch no earlier than tomorrow
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60*60*24)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            dLog(error)
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        let scheduler = Scheduler()
        
        scheduler.completionBlock = { success in
            task.setTaskCompleted(success: success)
        }
        
        scheduler.setupNotifications()
        
    }
    
    internal class Scheduler {
        var completionBlock: ((Bool)->())?
        func setupNotifications() {
            if let habits = try? HabitPersister().retrieve() {
                let notifier = HabitNotifier()
                for habit in habits {
                    notifier.addNotification(for: habit)
                }
                completionBlock?(true)
            } else {
                completionBlock?(false)
            }
        }
    }
}
