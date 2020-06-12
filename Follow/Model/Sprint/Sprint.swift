//
//  Sprint.swift
//  Follow
//
//  Created by Hunter Eisler on 6/12/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

struct Sprint: Codable {
    var name: String
    var expiry: Date
}

extension Sprint: Hashable {}

#if DEBUG
///"Check out a thrift store" lasts 10 days.
let testSprint = Sprint(name: "Check out a thrift store", expiry: Date(timeIntervalSinceNow: 60*60*24*10))
#endif
