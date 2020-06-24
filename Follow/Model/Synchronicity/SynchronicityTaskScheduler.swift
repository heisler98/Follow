//
//  SynchronicityTaskScheduler.swift
//  Follow
//
//  Created by Hunter Eisler on 6/24/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

let kFollowLastSetSynchronicityNotifyDate = "kFollowLastSetSynchronicityNotifyDate"

class SynchronicityTaskScheduler: HabitTaskScheduler {
    override var isManuallyScheduled: Bool {
        guard let lastScheduledDate = UserDefaults.standard.value(forKey: kFollowLastSetSynchronicityNotifyDate) as? Date else { return false }
        return Calendar.current.isDate(lastScheduledDate, inSameDayAs: Date())
    }
    
    override func manuallySchedule(_ completionBlock: ((Bool) -> ())?) {
        let scheduler = SynchronicityTaskScheduler.Scheduler()
        scheduler.completionBlock = completionBlock
        scheduler.setupNotifications()
    }
    
    internal class Scheduler: HabitTaskScheduler.Scheduler {
        override func setupNotifications() {
            if let synchronicities = try? SynchronicityPersister().retrieve() {
                let notifier = SynchronicityNotifier()
                for synchronicity in synchronicities {
                    notifier.addNotification(for: synchronicity)
                }
                completionBlock?(true)
            } else {
                completionBlock?(false)
            }
        }
    }
}
