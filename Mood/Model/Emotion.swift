//
//  Emotion.swift
//  Mood
//
//  Created by Nate Leake on 3/2/25.
//

import Foundation

class Emotion: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    /// Looks up what Mood this Emotion belongs to
    /// - Returns: An Optional Mood that this emotion belongs to
    func getParentMood() -> Mood? {
        var parent: Mood?
        for mood in Mood.allMoods {
            for emotion in mood.emotions {
                if self.name == emotion.name{
                    parent = mood
                }
            }
        }
        return parent
    }
    
    static let allEmotionNames: [String] = Mood.allMoods.flatMap{$0.emotions.map{$0.name}}
}
