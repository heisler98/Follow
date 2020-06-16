//
//  SprintTracked.swift
//  Follow
//
//  Created by Hunter Eisler on 6/15/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

struct SprintTracked: Codable {
    let date: Date
    let evaluation: [Sprint : Double]
    
    init(_ date: Date, evaluation: [Sprint : Double]) {
        self.date = date
        self.evaluation = evaluation
    }
}
