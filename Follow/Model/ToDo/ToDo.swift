//
//  ToDo.swift
//  Follow
//
//  Created by Hunter Eisler on 6/17/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

struct ToDo: Codable {
    ///The name of the ToDo item.
    var name: String
    ///`True` if the ToDo is persistent. `False` if the ToDo is finished after completion (one-off).
    var recurring: Bool
}

extension ToDo: Hashable {}
