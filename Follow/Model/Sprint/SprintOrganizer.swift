//
//  SprintOrganizer.swift
//  Follow
//
//  Created by Hunter Eisler on 6/12/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

class SprintOrganizer: ObservableObject {
    @Published var sprints: [Sprint]
    private var persister: SprintPersister
    private var notifier: SprintNotifier = SprintNotifier()
    
    func newSprint(_ sprint: Sprint) {
        self.sprints.append(sprint)
        notifier.addNotification(for: sprint)
        saveChanges()
    }
    
    func removeSprints(at offsets: IndexSet) {
        self.sprints.remove(atOffsets: offsets)
        saveChanges()
    }
    
    private func saveChanges() {
        DispatchQueue.global(qos: .userInitiated).sync {
            _ = persister.persist(self.sprints)
        }
    }
    
    func daysLeft(in sprint: Sprint) -> Int {
        let today = Date()
        let interval = today.timeIntervalSince(sprint.expiry) * -1
        return Int(interval/24/60/60)
    }
    
    convenience init() {
        self.init(withPersister: SprintPersister())
    }
    
    init(withPersister persister: SprintPersister) {
        do {
            self.sprints = try persister.retrieve()
        } catch {
            dLog(error)
            self.sprints = []
        }
        self.persister = persister
        checkExpiry()
    }
    
    private func checkExpiry() {
        let today = Date()
        for sprint in self.sprints {
            if sprint.expiry < today {
                self.sprints.remove(at: sprints.firstIndex(of: sprint)!)
            }
        }
        saveChanges()
    }
}
