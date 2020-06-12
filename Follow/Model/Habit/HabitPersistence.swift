//
//  HabitPersistence.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

///Mechanism for managing persistence of habits.
class HabitPersister {
    ///Storage mechanism for persistence URLs.
    struct Paths {
        private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        ///The save location of habits.
        static let saveDirectory = Paths.documentDirectory.appendingPathComponent("habits")
    }
    ///Saves an array of kind `Habit` to the default save directory.
    func persist(_ habits: [Habit]) -> Bool {
        do {
            let data = try JSONEncoder().encode(habits)
            try data.write(to: Paths.saveDirectory)
        } catch {
            dLog(error)
            return false
        }
        return true
    }
    ///Retrieves an array of kind `Habit` from the default save directory.
    func retrieve() throws -> [Habit] {
        guard FileManager.default.fileExists(atPath: Paths.saveDirectory.path) else {
            dLog("No file at path")
            throw NSError(domain: "com.eisler.Follow.HabitPersister.DocumentNotFoundAtPath", code: 1, userInfo: nil)
        }
        return try JSONDecoder().decode([Habit].self, from: try Data(contentsOf: Paths.saveDirectory))
    }
}
