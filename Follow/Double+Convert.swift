//
//  Double+Convert.swift
//  Follow
//
//  Created by Hunter Eisler on 6/13/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation

extension Double {
    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        // Example: if self = 1, fromRange = (0,2), toRange = (10,12) -> solution = 11
        var value = self
        value -= fromRange.0
        value /= Double(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0
        return value
    }
}
