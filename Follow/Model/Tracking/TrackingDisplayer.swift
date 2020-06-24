//
//  TrackingDisplayer.swift
//  Follow
//
//  Created by Hunter Eisler on 6/19/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import Charts

///Type for arranging Tracked data.
class TrackingDisplayer {
    var allTracked: [Tracked]
    
    func mostRecentData() -> RadarConfiguration {
        //Most recent Tracked entry
        guard let last = allTracked.last else { fatalError("No Tracked to display") }
        
        return RadarConfiguration(dataSet:
            RadarChartDataSet(entries:
                last.evaluation.values.map { RadarChartDataEntry(value: Double($0)) }))
    }
    
    convenience init() {
        self.init(withPersister: TrackingPersister())
    }
    
    init(withPersister persister: TrackingPersister) {
        do {
            self.allTracked = try persister.retrieve()
        } catch {
            dLog(error)
            self.allTracked = []
        }
    }
}
