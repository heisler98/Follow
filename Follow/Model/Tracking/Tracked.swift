//
//  Tracked.swift
//  Follow
//
//  Created by Hunter Eisler on 6/12/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

struct Tracked: Codable {
    let date: Date
    let evaluation: [Habit : Float]
    
    init(_ date: Date, evaluation: [Habit : Float]) {
        self.date = date
        self.evaluation = evaluation
        
    }
}
