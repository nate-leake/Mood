//
//  AnalyticsGenerator.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation

/// On device calulations for analytics of the recent data
struct AnalyticsGenerator {
    private var moods: [Mood] = Mood.allMoods
    private var contexts: [String] = ["family", "finances", "health", "identity", "politics", "weather", "work"]
    
    /// Sorts contexts by their weight
    /// - Parameter data: A list of DailyData that should be analyzed
    /// - Returns: A list of type String which is the context. This is sorted greatest to least by weight
    func biggestImpact(data: [DailyData]) -> [String] {
        var impacts: [String] = []
        
        var totals : [String: Int] = [:]
        
        for context in contexts {
            totals[context] = 0
        }
        
        for day in data {
            for pair in day.pairs {
                totals[pair.context] = totals[pair.context]! + pair.weight.rawValue
            }
        }
        
        let sortedTotals = totals.sorted{$0.1 > $1.1}
        let highest = sortedTotals[0].value
        
        for kv in sortedTotals {
            if kv.value == highest {
                impacts.append(kv.key)
            } else {
                break
            }
        }
        
        
        return impacts
    }
    
    /// Sorts the top 4 most frequently logged emotions
    /// - Returns: A sorted list of type String of the top 4 most logged emotions
    func biggestEmotions() -> [String] {
        var emotions: [String] = []
        let limit = 4
        
        var totals : [String: Int] = [:]
        
        for mood in moods {
            for emotion in mood.emotions {
                totals[emotion.name] = 0
            }
        }
        
        for day in DailyData.MOCK_DATA {
            for pair in day.pairs {
                for mood in pair.emotions{
                    totals[mood] = totals[mood]! + 1
                }
                
            }
        }
        
        let sortedTotals = totals.sorted{$0.1 > $1.1}
        
        for kv in sortedTotals {
            if emotions.count < limit {
                emotions.append(kv.key)
            } else {
                break
            }
        }
        
        
        return emotions
    }
}
