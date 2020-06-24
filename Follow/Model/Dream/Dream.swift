//
//  Dream.swift
//  Follow
//
//  Created by Hunter Eisler on 6/24/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

struct Dream: Codable {
    var date: Date
    var journal: String
}

extension Dream: Hashable {}

extension Dream {
    var title: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self.date)
    }
}

extension Dream: Identifiable {
    var id: String {
        return UUID().uuidString
    }
}

#if DEBUG
let testDream = Dream(date: Date(), journal: "This is a dream!")
#endif
