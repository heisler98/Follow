//
//  HabitTaskScheduler.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import BackgroundTasks

let kFollowLastSetNotifyDate = "kFollowLastSetNotifyDate"

class HabitTaskScheduler {
    @Published var showFireworks: Bool = false
    
    var isManuallyScheduled: Bool {
        guard let lastScheduledDate = UserDefaults.standard.value(forKey: kFollowLastSetNotifyDate) as? Date else { return false }
        return Calendar.current.isDate(lastScheduledDate, inSameDayAs: Date())
    }
    
    func manuallySchedule(_ completionBlock: ((Bool) -> ())?) {
        let scheduler = Scheduler()
        scheduler.completionBlock = completionBlock
        scheduler.setupNotifications()
        self.showFireworks = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.showFireworks = false
        }
        
    }
    
    ///Registers a background task with the scheduler object.
    func register() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.eisler.Follow.refreshNotifications", using: DispatchQueue.global(qos: .background)) { (task) in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    ///Schedules the next background task.
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
    
    ///Performs the background task.
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        let scheduler = Scheduler()
        
        scheduler.completionBlock = { success in
            task.setTaskCompleted(success: success)
        }
        
        scheduler.setupNotifications()
        
    }
    ///A type responsible for performing scheduling tasks.
    internal class Scheduler {
        ///A block that executes upon completion, passing `true` if successful.
        var completionBlock: ((Bool)->())?
        ///Schedules notifications for the complete list of habits.
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
