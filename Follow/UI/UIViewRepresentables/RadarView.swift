//
//  RadarChartView.swift
//  Follow
//
//  Created by Hunter Eisler on 6/19/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import UIKit
import SwiftUI
import Charts

struct RadarConfiguration {
    let dataSet: RadarChartDataSet
}

struct RadarView: UIViewRepresentable {
    
    @Binding var configuration: RadarConfiguration
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> RadarChartView {
        let radarChart = RadarChartView()
        return radarChart
    }
    
    func updateUIView(_ radarChart: RadarChartView, context: Context) {
        radarChart.data = RadarChartData(dataSet: configuration.dataSet)
        radarChart.notifyDataSetChanged()
    }
    
    class Coordinator {
        var parent: RadarView
        
        init(_ parent: RadarView) {
            self.parent = parent
        }
    }
}
