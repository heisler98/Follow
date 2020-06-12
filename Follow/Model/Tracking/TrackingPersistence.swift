//
//  TrackingPersistence.swift
//  Follow
//
//  Created by Hunter Eisler on 6/12/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

///Mechanism for managing persistence of track evaluations.
class TrackingPersister {
    ///Storage mechanism for persistence URLs.
    struct Paths {
        private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        ///The save location of track evals.
        static let saveDirectory = Paths.documentDirectory.appendingPathComponent("tracking")
    }
    ///Saves an array of kind `Tracked` to the default save directory.
    func persist(_ tracked: [Tracked]) -> Bool {
        do {
            let data = try JSONEncoder().encode(tracked)
            try data.write(to: Paths.saveDirectory)
        } catch {
            dLog(error)
            return false
        }
        return true
    }
    ///Retrieves an array of kind `Tracked` from the default save directory.
    func retrieve() throws -> [Tracked] {
        guard FileManager.default.fileExists(atPath: Paths.saveDirectory.path) else {
            dLog("No tracking file at path")
            throw NSError(domain: "com.eisler.Follow.HabitPersister.TrackingDocumentNotFoundAtPath", code: 1, userInfo: nil)
        }
        return try JSONDecoder().decode([Tracked].self, from: Data(contentsOf: Paths.saveDirectory))
    }
}
