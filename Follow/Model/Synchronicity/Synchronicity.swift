//
//  Synchronicity.swift
//  Follow
//
//  Created by Hunter Eisler on 6/24/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

struct Synchronicity: Codable {
    var name: String
    var frequency: Double
}

extension Synchronicity: Hashable {}

#if DEBUG
let testSynchronicity = Synchronicity(name: "Candle", frequency: 3)
#endif
