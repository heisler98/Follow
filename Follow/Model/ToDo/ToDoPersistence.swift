//
//  ToDoPersistence.swift
//  Follow
//
//  Created by Hunter Eisler on 6/17/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

///Mechanism for managing persistence of ToDos.
class ToDoPersister {
    struct Paths {
        private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let saveDirectory = Paths.documentDirectory.appendingPathComponent("todos")
    }
    
    ///Saves an array of kind `ToDo` to the default save directory.
    func persist(_ todos: [ToDo]) -> Bool {
        do {
            let data = try JSONEncoder().encode(todos)
            try data.write(to: Paths.saveDirectory)
        } catch {
            dLog(error)
            return false
        }
        return true
    }
    
    func retrieve() throws -> [ToDo] {
        guard FileManager.default.fileExists(atPath: Paths.saveDirectory.path) else {
            dLog("No sprint file at path")
            throw NSError(domain: "com.eisler.Follow.HabitPersister.ToDoDocumentNotFoundAtPath", code: 1, userInfo: nil)
        }
        return try JSONDecoder().decode([ToDo].self, from: try Data(contentsOf: Paths.saveDirectory))
    }
}
