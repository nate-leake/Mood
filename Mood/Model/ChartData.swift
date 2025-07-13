//
//  ChartData.swift
//  Mood
//
//  Created by Nate Leake on 7/7/25.
//

import Foundation
import SwiftUI
import Charts

struct PieChartData: Identifiable {
    var id: String
    var value: Int
    var category: String
    var color: Color
    
    init(id: String = UUID().uuidString, value: Int, category: String, color: Color) {
        self.id = id
        self.value = value
        self.category = category
        self.color = color
        
    }
}

struct LineChartData: Identifiable {
    var id: String
    var date: Date
    var value: Int
    var category: String
    var color: Color
    
    init(id: String = UUID().uuidString, date: Date, value: Int, category: String, color: Color) {
        self.id = id
        self.value = value
        self.category = category
        self.date = date
        self.color = color
    }
    
}

struct BarChartData: Identifiable {
    var id: String
    var date: Date
    var value: Int
    var color: Color
    
    init(id: String = UUID().uuidString, date: Date, value: Int, color: Color) {
        self.id = id
        self.date = date
        self.value = value
        self.color = color
    }
}
