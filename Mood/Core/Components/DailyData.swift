//
//  DailyData.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation


struct DailyData {
    var date: Date
    var pairs: [ContextEmotionPair]
    
    init(date: Date, pairs: [ContextEmotionPair]) {
        self.date = date
        self.pairs = pairs
    }
}

extension DailyData {
    static var MOCK_DATA : [DailyData] = [
        .init(date: Date(),
              pairs: [ContextEmotionPair(context: "family", emotions: ["happy", "indifferent"], weight: .slight),
                      ContextEmotionPair(context: "health", emotions: ["calm"], weight: .slight),
                      ContextEmotionPair(context: "identity", emotions: ["content", "confident"], weight: .moderate),
                      ContextEmotionPair(context: "finances", emotions: ["happy", "satisfied"], weight: .moderate),
                      ContextEmotionPair(context: "politics", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "weather", emotions: ["happy", "peaceful"], weight: .moderate),
                      ContextEmotionPair(context: "work", emotions: ["indifferent", "hopeful"], weight: .slight)
                     ]),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
              pairs: [ContextEmotionPair(context: "family", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "health", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "identity", emotions: ["happy"], weight: .slight),
                      ContextEmotionPair(context: "finances", emotions: ["calm", "satisfied"], weight: .moderate),
                      ContextEmotionPair(context: "politics", emotions: ["anxious"], weight: .slight),
                      ContextEmotionPair(context: "weather", emotions: ["sad", "disappointed"], weight: .moderate),
                      ContextEmotionPair(context: "work", emotions: ["indifferent"], weight: .slight)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
              pairs: [ContextEmotionPair(context: "family", emotions: ["happy"], weight: .extreme),
                      ContextEmotionPair(context: "health", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "identity", emotions: ["happy", "confident"], weight: .moderate),
                      ContextEmotionPair(context: "finances", emotions: ["excited"], weight: .slight),
                      ContextEmotionPair(context: "politics", emotions: ["nervous"], weight: .moderate),
                      ContextEmotionPair(context: "weather", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "work", emotions: ["angry", "disappointed"], weight: .moderate)
                     ]
             )
    ]
}
