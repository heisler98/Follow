//
//  TrackingOrganizer.swift
//  Follow
//
//  Created by Hunter Eisler on 6/12/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

class TrackingOrganizer : ObservableObject {
    @Published var tracked: [Tracked]
    private var persister: TrackingPersister
    
    func newTrack(_ track: Tracked) {
        tracked.append(track)
        saveChanges()
        
    }
    
    private func saveChanges() {
        DispatchQueue.global(qos: .userInitiated).sync {
            _ = persister.persist(self.tracked)
        }
    }
    
    convenience init() {
        self.init(withPersister: TrackingPersister())
    }
    
    init(withPersister persister: TrackingPersister) {
        do {
            self.tracked = try persister.retrieve()
        } catch {
            dLog(error)
            self.tracked = [Tracked]()
        }
        
        self.persister = persister
    }
}
