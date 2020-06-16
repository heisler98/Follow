//
//  SprintTrackingPersistence.swift
//  Follow
//
//  Created by Hunter Eisler on 6/15/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

class SprintTrackingPersister {
    struct Paths {
        private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let saveDirectory = Paths.documentDirectory.appendingPathComponent("sprint_tracking")
    }
    
    func persist(_ tracked: [SprintTracked]) -> Bool {
        do {
            let data = try JSONEncoder().encode(tracked)
            try data.write(to: Paths.saveDirectory)
        } catch {
            dLog(error)
            return false
        }
        return true
    }
    
    func retrieve() throws -> [SprintTracked] {
        guard FileManager.default.fileExists(atPath: Paths.saveDirectory.path) else {
            dLog("No sprint tracking file at path")
            throw NSError(domain: "com.eisler.Follow.SprintHabitPersister.SprintTrackingDocumentNotFoundAtPath", code: 1, userInfo: nil)
        }
        return try JSONDecoder().decode([SprintTracked].self, from: Data(contentsOf: Paths.saveDirectory))
    }
}
