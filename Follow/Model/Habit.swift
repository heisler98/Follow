//
//  Habit.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

struct Habit: Codable {
    var name: String
}

extension Habit: Hashable {}

#if DEBUG
let testHabit = Habit(name: "Read Core Transformation")
#endif
