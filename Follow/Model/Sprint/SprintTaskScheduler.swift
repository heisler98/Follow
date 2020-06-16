//
//  SprintTaskScheduler.swift
//  Follow
//
//  Created by Hunter Eisler on 6/15/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

let kFollowLastSetSprintNotifyDate = "kFollowLastSetSprintNotifyDate"

class SprintTaskScheduler: HabitTaskScheduler {
    override var isManuallyScheduled: Bool {
        guard let lastScheduledDate = UserDefaults.standard.value(forKey: kFollowLastSetSprintNotifyDate) as? Date else { return false }
        return Calendar.current.isDate(lastScheduledDate, inSameDayAs: Date())
    }
    
    override func manuallySchedule(_ completionBlock: ((Bool) -> ())?) {
        let scheduler = Scheduler()
        scheduler.completionBlock = completionBlock
        scheduler.setupNotifications()
    }
    
    internal class Scheduler: HabitTaskScheduler.Scheduler {
        override func setupNotifications() {
            if let sprints = try? SprintPersister().retrieve() {
                let notifier = SprintNotifier()
                for sprint in sprints {
                    notifier.addNotification(for: sprint)
                }
                completionBlock?(true)
            } else {
                completionBlock?(false)
            }
        }
    }
}
