//
//  Mood.swift
//  Mood
//
//  Created by Nate Leake on 3/2/25.
//

import Foundation
import SwiftUI

/// A mood with the acceptable emotions associated to it
class Mood: Codable, Equatable {
    var name: String
    var emotions: [Emotion]
    
    init(name: String, emotions: [Emotion]) {
        self.name = name
        self.emotions = emotions
    }
    
    func getColor() -> Color {
        return Color(self.name)
    }
    
    static func getMood(from: String) -> Mood? {
        var matchedMood: Mood?
        
        for mood in self.allMoods {
            if mood.name == from {
                matchedMood = mood
            }
        }
        
        return matchedMood
    }
    
    static func ==(lhs: Mood, rhs: Mood) -> Bool {
        return lhs.name == rhs.name
    }
    
    static let allMoods: [Mood] = Bundle.main.decode(file: "moods.json")
    static let allMoodNames: [String] = allMoods.map{$0.name}
    static let sampleMood: Mood = allMoods[0]
}
