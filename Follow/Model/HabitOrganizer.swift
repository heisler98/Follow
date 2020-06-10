//
//  HabitOrganizer.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import Combine

class HabitOrganizer: ObservableObject {
    
    @Published var habits: [Habit]
    @Published var lastSaveSucceeded: Bool = true
    private var persister: HabitPersister
    private var notifier: HabitNotifier = HabitNotifier()
    
    func newHabit(_ habit: Habit) {
        self.habits.append(habit)
        notifier.addNotification(for: habit)
        saveChanges()
    }
    
    func deleteHabit(_ index: Int) {
        self.habits.remove(at: index)
        saveChanges()
    }
    
    private func saveChanges() {
        var success = false
        DispatchQueue.global(qos: .background).sync {
            success = persister.persist(self.habits)
        }
        lastSaveSucceeded = success
    }
    
    private func loadChanges() {
        do {
            self.habits = try persister.retrieve()
        } catch {
            dLog(error)
        }
    }
    
    convenience init() {
        self.init(withPersister: HabitPersister())
    }
    
    init(withPersister persister: HabitPersister) {
        do {
            self.habits = try persister.retrieve()
        } catch {
            dLog(error)
            self.habits = [Habit]()
        }
        
        self.persister = persister
    }
    
    init(_ habits: [Habit]) {
        self.habits = habits
        self.persister = HabitPersister()
    }
}
