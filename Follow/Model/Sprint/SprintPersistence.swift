//
//  SprintPersistence.swift
//  Follow
//
//  Created by Hunter Eisler on 6/12/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

///Mechanism for managing persistence of sprints.
class SprintPersister {
    ///Storage mechanism for persistence URLs.
    struct Paths {
        private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        ///The save location of sprints.
        static let saveDirectory = Paths.documentDirectory.appendingPathComponent("sprints")
    }
    
    ///Saves an array of kind `Sprint` to the default save directory.
    func persist(_ sprints: [Sprint]) -> Bool {
        do {
            let data = try JSONEncoder().encode(sprints)
            try data.write(to: Paths.saveDirectory)
        } catch {
            dLog(error)
            return false
        }
        return true
    }
    
    ///Retrieves an array of kind `Sprint` from the default save directory.
    func retrieve() throws -> [Sprint] {
        guard FileManager.default.fileExists(atPath: Paths.saveDirectory.path) else {
            dLog("No sprint file at path")
            throw NSError(domain: "com.eisler.Follow.SprintPersister.SprintDocumentNotFoundAtPath", code: 1, userInfo: nil)
        }
        return try JSONDecoder().decode([Sprint].self, from: try Data(contentsOf: Paths.saveDirectory))
    }
}
