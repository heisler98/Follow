//
//  DreamPersistence.swift
//  Follow
//
//  Created by Hunter Eisler on 6/24/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

class DreamPersister {
    struct Paths {
        private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let saveDirectory = Paths.documentDirectory.appendingPathComponent("dreams")
        static let trashDirectory = Paths.documentDirectory.appendingPathComponent("dreams_Trash")
        static let notionPath = Bundle.main.url(forResource: "NotionDreams", withExtension: "json")
    }
    
    func persist(_ dreams: [Dream]) -> Bool {
        do {
            let data = try JSONEncoder().encode(dreams)
            try data.write(to: Paths.saveDirectory)
        } catch {
            dLog(error)
            return false
        }
        return true
    }
    
    func trash(_ dreams: [Dream]) -> Bool {
        do {
            let data = try JSONEncoder().encode(dreams)
            try data.write(to: Paths.trashDirectory)
        } catch {
            dLog(error)
            return false
        }
        return true
    }
    
    func retrieve() throws -> [Dream] {
        guard FileManager.default.fileExists(atPath: Paths.saveDirectory.path) else {
            // load dreams from Notion
            dLog("No dream file at path")
            guard let bundleURL = Paths.notionPath else {
                dLog("Invalid bundle")
                fatalError()
            }
            return try JSONDecoder().decode([Dream].self, from: try Data(contentsOf: bundleURL))
        }
        return try JSONDecoder().decode([Dream].self, from: try Data(contentsOf: Paths.saveDirectory))
    }
}
