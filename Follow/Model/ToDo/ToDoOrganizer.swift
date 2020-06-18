//
//  ToDoOrganizer.swift
//  Follow
//
//  Created by Hunter Eisler on 6/17/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

class ToDoOrganizer: ObservableObject {
    @Published var todos: [ToDo]
    private var persister: ToDoPersister
    
    func newToDo(_ todo: ToDo) {
        self.todos.append(todo)
        saveChanges()
    }
    
    func deleteToDo(_ index: Int) {
        self.todos.remove(at: index)
        saveChanges()
    }
    
    func removeTodos(at offsets: IndexSet) {
        self.todos.remove(atOffsets: offsets)
        saveChanges()
    }
    
    private func saveChanges() {
        DispatchQueue.global(qos: .background).sync {
            _ = persister.persist(self.todos)
        }
    }
    
    convenience init() {
        self.init(withPersister: ToDoPersister())
    }
    
    init(withPersister persister: ToDoPersister) {
        do {
            self.todos = try persister.retrieve()
        } catch {
            dLog(error)
            self.todos = [ToDo]()
        }
        self.persister = persister
    }
    
    init(_ todos: [ToDo]) {
        self.todos = todos
        self.persister = ToDoPersister()
    }
}
