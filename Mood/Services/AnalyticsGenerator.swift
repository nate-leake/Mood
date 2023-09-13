//
//  AnalyticsGenerator.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation

struct AnalyticsGenerator {    
    func getMoodsFromJSON() -> ContextMoodJSON? {
        var contextMoodJSON : ContextMoodJSON?
        do {
            if let bundlePath = Bundle.main.path(forResource: "moods", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                // Decoding the Product type from JSON data using JSONDecoder() class.
                let product = try JSONDecoder().decode(ContextMoodJSON.self, from: jsonData)
                contextMoodJSON = product
            }
        } catch {
            print(error)
        }
        
        return contextMoodJSON
    }
    
    func biggestImpact() -> [String] {
        let decoded = getMoodsFromJSON()
        var impacts: [String] = []
        
        if let data = decoded{
            
            var totals : [String: Int] = [:]
            
            for context in data.contexts {
                totals[context] = 0
            }
                        
            for day in DailyData.MOCK_DATA {
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
        }
        
        return impacts
    }
    
    func biggestEmotions() -> [String] {
        let decoded = getMoodsFromJSON()
        var emotions: [String] = []
        let limit = 4
        
        if let data = decoded{
            
            var totals : [String: Int] = [:]
            
            for mood in data.moods {
                for emotion in mood.value {
                    totals[emotion] = 0
                }
            }
                        
            for day in DailyData.MOCK_DATA {
                for pair in day.pairs {
                    for mood in pair.moods{
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
        }
        
        return emotions
    }
}
