//
//  DoubleExtension.swift
//  Mood
//
//  Created by Nate Leake on 7/6/25.
//

import Foundation


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func roundedString(toPlaces places: Int) -> String {
        let rounded = self.rounded(toPlaces: places)
        return String(format: "%.\(places)f", rounded)
    }
}

