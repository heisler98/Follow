//
//  SprintTrackingOrganizer.swift
//  Follow
//
//  Created by Hunter Eisler on 6/15/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

class SprintTrackingOrganizer: ObservableObject {
    @Published var tracked: [SprintTracked]
    private var persister: SprintTrackingPersister
    
    func newTrack(_ track: SprintTracked) {
        tracked.append(track)
        saveChanges()
    }
    
    private func saveChanges() {
        DispatchQueue.global(qos: .userInitiated).sync {
            _ = persister.persist(self.tracked)
        }
    }
    
    convenience init() {
        self.init(withPersister: SprintTrackingPersister())
    }
    
    init(withPersister persister: SprintTrackingPersister) {
        do {
            self.tracked = try persister.retrieve()
        } catch {
            dLog(error)
            self.tracked = [SprintTracked]()
        }
        
        self.persister = persister
    }
}
