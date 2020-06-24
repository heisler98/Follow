//
//  SynchronicityOrganizer.swift
//  Follow
//
//  Created by Hunter Eisler on 6/24/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

class SynchronicityOrganizer: ObservableObject {
    @Published var synchronicities: [Synchronicity]
    private var persister: SynchronicityPersister
    private var notifier: SynchronicityNotifier = SynchronicityNotifier()
    
    func newSynchronicity(_ synchronicity: Synchronicity) {
        self.synchronicities.append(synchronicity)
        notifier.addNotification(for: synchronicity)
        saveChanges()
    }
    
    func removeSynchronicities(at offsets: IndexSet) {
        self.synchronicities.remove(atOffsets: offsets)
        saveChanges()
    }
    
    private func saveChanges() {
        DispatchQueue.global(qos: .background).sync {
            _ = persister.persist(self.synchronicities)
        }
    }
    
    private func loadChanges() {
        do {
            self.synchronicities = try persister.retrieve()
        } catch {
            dLog(error)
        }
    }
    
    convenience init() {
        self.init(withPersister: SynchronicityPersister())
    }
    
    init(withPersister persister: SynchronicityPersister) {
        do {
            self.synchronicities = try persister.retrieve()
        } catch {
            dLog(error)
            self.synchronicities = []
        }
        
        self.persister = persister
    }
    
    init(_ synchronicities: [Synchronicity]) {
        self.synchronicities = synchronicities
        self.persister = SynchronicityPersister()
    }
}
