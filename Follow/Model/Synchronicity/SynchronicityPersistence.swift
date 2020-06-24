//
//  SynchronicityPersistence.swift
//  Follow
//
//  Created by Hunter Eisler on 6/24/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

class SynchronicityPersister {
    struct Paths {
        private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let saveDirectory = Paths.documentDirectory.appendingPathComponent("synchronicities")
    }
    
    @discardableResult
    func persist(_ synchronicities: [Synchronicity]) -> Bool {
        do {
            let data = try JSONEncoder().encode(synchronicities)
            try data.write(to: Paths.saveDirectory)
        } catch {
            dLog(error)
            return false
        }
        return true
    }
    
    func retrieve() throws -> [Synchronicity] {
        guard FileManager.default.fileExists(atPath: Paths.saveDirectory.path) else {
            dLog("No synchronicity file at path")
            throw NSError(domain: "com.eisler.Follow.SynchronicityPersister.SynchDocumentNotFoundAtPath", code: 1, userInfo: nil)
        }
        return try JSONDecoder().decode([Synchronicity].self, from: try Data(contentsOf: Paths.saveDirectory))
    }
}
