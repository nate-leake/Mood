//
//  AnalyticsGenerator.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation

/// On device calculations for analytics of the recent data
class AnalyticsGenerator : ObservableObject {
    private var moods: [Mood] = Mood.allMoods
    @Published var todaysBiggestImpacts: [String] = []
    
    static public var shared = AnalyticsGenerator()
    
    private func cp(_ text: String, state: PrintableStates = .none) {
        let finalString = "📈\(state.rawValue) ANALYTICS GENERATOR: " + text
        print(finalString)
    }
    
    func calculateTBI(dataService: DataService = DataService.shared){
        if let data = dataService.todaysDailyData {
            todaysBiggestImpacts = biggestImpact(data: [data])
        }
    }
    
    func aggregateMoodIntensityTotals(moodData: [MoodData]) -> [(
        mood: String,
        intensity: Int
    )] {
        var groupedItems = [String: Int]()
        
        for mood in moodData {
            groupedItems[mood.moodType, default: 0] += mood.intensity
        }
        
        groupedItems = groupedItems.filter { $0.value != 0 }
        
        // Step 2: Convert the dictionary to an array and sort by quantity in descending order
        let sortedItems = groupedItems.map {
            (mood: $0.key, intensity: $0.value)
        }
            .sorted {
                if $0.intensity == $1.intensity {
                    $0.mood < $1.mood
                } else {
                    $0.intensity > $1.intensity
                }
            }
        
        return sortedItems
    }
    
    func aggregateMoodIntensityByDate(moodPosts: [UnsecureMoodPost]) -> [MoodData]{
        var tmpData: [MoodData] = []
        for post in moodPosts {
            for contextLogContainer in post.contextLogContainers {
                let contextId = contextLogContainer.contextId
                for moodLogContainer in contextLogContainer.moodContainers {
                    tmpData.append(
                        MoodData(
                            date: Calendar.current.startOfDay(
                                for: post.timestamp
                            ),
                            contextId: contextId,
                            moodType: moodLogContainer.moodName,
                            intensity: moodLogContainer.weight.rawValue
                        )
                    )
                }
            }
        }
        
        // Dictionary to hold aggregated values
        var aggregatedData: [String: [String: Int]] = [:] // [date: [moodType: intensity]]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Assumes dates are formatted by day
        
        for data in tmpData {
            let dateKey = dateFormatter.string(from: data.date)
            if aggregatedData[dateKey] == nil {
                aggregatedData[dateKey] = [:]
            }
            aggregatedData[dateKey]![
                data.moodType,
                default: 0
            ] += data.intensity
        }
        
        // Convert aggregated data back to MoodData
        var result: [MoodData] = []
        
        for (dateString, moodTypes) in aggregatedData {
            guard let date = dateFormatter.date(from: dateString) else {
                continue
            }
            for (moodType, intensity) in moodTypes {
                result
                    .append(
                        MoodData(
                            date: date,
                            contextId: "",
                            moodType: moodType,
                            intensity: intensity
                        )
                    )
            }
        }
        
        // Ensure each day has exactly 5 mood types
        let expectedMoodTypes: Set<String> = Set(
            Mood.allMoodNames
        ) 
        
        var finalResult: [MoodData] = []
        
        // Iterate through dates to check for missing mood types
        let groupedByDate = Dictionary(
            grouping: result,
            by: { dateFormatter.string(from: $0.date)
            })
        
        for (dateString, moods) in groupedByDate {
            guard let date = dateFormatter.date(from: dateString) else {
                continue
            }
            let existingMoodTypes = Set(moods.map { $0.moodType })
            let missingMoodTypes = expectedMoodTypes.subtracting(
                existingMoodTypes
            )
            
            finalResult.append(contentsOf: moods)
            
            // Add missing mood types with intensity 0
            for moodType in missingMoodTypes {
                finalResult
                    .append(
                        MoodData(
                            date: date,
                            contextId: "",
                            moodType: moodType,
                            intensity: 0
                        )
                    )
            }
        }
        
        return finalResult.sorted{ $0.date < $1.date }
    }
    
    /// Sorts contexts by their weight
    /// - Parameter data: A list of DailyData that should be analyzed
    /// - Returns: A list of type String which is the context. This is sorted greatest to least by weight
    func biggestImpact(data: [DailyData]) -> [String] {
        cp("calculating biggest impact...")
        var impacts: [String] = []
        
        var totals : [String: Int] = [:]
        
        for context in DataService.shared.loadedContexts {
            totals[context.name] = 0
        }
        
        for day in data {
            for contextLogContainer in day.contextLogContainers {
                cp(
                    "\(contextLogContainer.contextId) \(contextLogContainer.contextName)"
                )
                
                totals[contextLogContainer.contextName] = contextLogContainer.totalWeight
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
            for contextLogContainer in day.contextLogContainers {
                for moodContainer in contextLogContainer.moodContainers {
                    for mood in moodContainer.emotions{
                        totals[mood] = totals[mood]! + 1
                    }
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
