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
    
    func streakForHabit(_ habit: Habit) -> Int {
        let specificTracks = self.tracked.filter { return $0.evaluation.keys.contains(habit) }
        var streakCount = 0
        let enumeration = specificTracks.enumerated()
        for (index, track) in enumeration {
            guard (index) <= (specificTracks.count-1) else { return streakCount }
            if track.date.timeIntervalSince(specificTracks[index+1].date) > (60*60*24) {
                streakCount += 1
            }
        }
        
        return streakCount
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
