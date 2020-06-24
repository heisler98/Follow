//
//  DreamOrganizer.swift
//  Follow
//
//  Created by Hunter Eisler on 6/24/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

class DreamOrganizer: ObservableObject {
    @Published var dreams: [Dream]
    private var persister: DreamPersister
    
    func newDream(_ dream: Dream) {
        self.dreams.insert(dream, at: 0)
        saveChanges()
    }
    
    func removeDreams(at offsets: IndexSet) {
        self.dreams.remove(atOffsets: offsets)
        saveChanges()
    }
    
    private func saveChanges() {
        DispatchQueue.global(qos: .background).sync {
            _ = persister.persist(self.dreams)
        }
    }
    
    convenience init() {
        self.init(withPersister: DreamPersister())
    }
    
    init(withPersister persister: DreamPersister) {
        do {
            self.dreams = try persister.retrieve()
        } catch {
            dLog(error)
            self.dreams = []
        }
        self.persister = persister
    }
    
    init(_ dreams: [Dream]) {
        self.dreams = dreams
        self.persister = DreamPersister()
    }
}
