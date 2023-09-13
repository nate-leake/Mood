//
//  DailyData.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation


struct DailyData {
    var date: Date
    var pairs: [ContextMoodPair]
    
    init(date: Date, pairs: [ContextMoodPair]) {
        self.date = date
        self.pairs = pairs
    }
}

extension DailyData {
    static var MOCK_DATA : [DailyData] = [
        .init(date: Date(),
              pairs: [ContextMoodPair(context: "family", moods: ["happy", "indifferent"], weight: .slight),
                      ContextMoodPair(context: "health", moods: ["calm"], weight: .slight),
                      ContextMoodPair(context: "identity", moods: ["content", "confident"], weight: .moderate),
                      ContextMoodPair(context: "finances", moods: ["happy", "satisfied"], weight: .moderate),
                      ContextMoodPair(context: "politics", moods: ["indifferent"], weight: .slight),
                      ContextMoodPair(context: "weather", moods: ["happy", "peaceful"], weight: .moderate),
                      ContextMoodPair(context: "work", moods: ["indifferent", "hopeful"], weight: .slight)
                     ]),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
              pairs: [ContextMoodPair(context: "family", moods: ["indifferent"], weight: .slight),
                      ContextMoodPair(context: "health", moods: ["indifferent"], weight: .slight),
                      ContextMoodPair(context: "identity", moods: ["happy"], weight: .slight),
                      ContextMoodPair(context: "finances", moods: ["calm", "satisfied"], weight: .moderate),
                      ContextMoodPair(context: "politics", moods: ["anxious"], weight: .slight),
                      ContextMoodPair(context: "weather", moods: ["sad", "disappointed"], weight: .moderate),
                      ContextMoodPair(context: "work", moods: ["indifferent"], weight: .slight)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
              pairs: [ContextMoodPair(context: "family", moods: ["happy"], weight: .extreme),
                      ContextMoodPair(context: "health", moods: ["indifferent"], weight: .slight),
                      ContextMoodPair(context: "identity", moods: ["happy", "confident"], weight: .moderate),
                      ContextMoodPair(context: "finances", moods: ["excited"], weight: .slight),
                      ContextMoodPair(context: "politics", moods: ["nervous"], weight: .moderate),
                      ContextMoodPair(context: "weather", moods: ["indifferent"], weight: .slight),
                      ContextMoodPair(context: "work", moods: ["angry", "disappointed"], weight: .moderate)
                     ]
             )
    ]
}
