//
//  DailyData.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation


/// Stores the ContextEmotionPairs from the user's log for that day
class DailyData: Codable, Hashable{
    var date: Date
    var timeZoneOffset: Int
    var pairs: [ContextEmotionPair]
    
    // conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
    
    // conform to Equatable
    static func ==(lhs: DailyData, rhs: DailyData) -> Bool {
        return lhs.date == rhs.date
    }
    
    init(date: Date, timeZoneOffset: Int, pairs: [ContextEmotionPair]) {
        self.date = date
        self.pairs = pairs
        self.timeZoneOffset = timeZoneOffset
    }
    
    func addPair(pair: ContextEmotionPair){
        let matchedPair = self.getPair(withContext: pair.contextName)
        
        if matchedPair != nil {
            matchedPair?.emotions = pair.emotions
        } else {
            self.pairs.append(pair)
        }
    }
    
    func getPair(withContext: String) -> ContextEmotionPair? {
        var matchedPair: ContextEmotionPair?
        for p in pairs {
            if p.contextName == withContext{
                matchedPair = p
            }
        }
        
        return matchedPair
    }
    
    func containsPair(withContext contextName: String) -> Bool {
        // Check logic to return the correct result.
        print("daily data result for \(contextName):", pairs.contains { $0.contextName == contextName })
        return pairs.contains { $0.contextName == contextName }
    }
}

extension DailyData {
    static var TZO = TimeZone.current.secondsFromGMT(for: Date())
    static var MOCK_DATA : [DailyData] = [
        .init(date: Date(), timeZoneOffset: TZO,
              pairs: [ContextEmotionPair(context: "behavior", emotions: ["happy", "indifferent"], weight: .slight),
                      ContextEmotionPair(context: "hobbies", emotions: ["calm"], weight: .none),
                      ContextEmotionPair(context: "finances", emotions: ["happy", "satisfied"], weight: .moderate),
                      ContextEmotionPair(context: "weather", emotions: ["happy", "peaceful"], weight: .extreme),
                      ContextEmotionPair(context: "work", emotions: ["indifferent", "hopeful"], weight: .slight)
                     ]),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextEmotionPair(context: "family", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "health", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "hobbies", emotions: ["calm"], weight: .moderate),
                      ContextEmotionPair(context: "identity", emotions: ["happy"], weight: .slight),
                      ContextEmotionPair(context: "finances", emotions: ["calm", "satisfied"], weight: .moderate),
                      ContextEmotionPair(context: "politics", emotions: ["anxious"], weight: .slight),
                      ContextEmotionPair(context: "weather", emotions: ["sad", "disappointed"], weight: .moderate),
                      ContextEmotionPair(context: "work", emotions: ["indifferent"], weight: .slight)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextEmotionPair(context: "family", emotions: ["happy"], weight: .extreme),
                      ContextEmotionPair(context: "identity", emotions: ["happy", "confident"], weight: .moderate),
                      ContextEmotionPair(context: "finances", emotions: ["excited"], weight: .slight),
                      ContextEmotionPair(context: "weather", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "social", emotions: ["angry", "disappointed"], weight: .moderate)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextEmotionPair(context: "family", emotions: ["happy", "indifferent"], weight: .slight),
                      ContextEmotionPair(context: "health", emotions: ["calm"], weight: .slight),
                      ContextEmotionPair(context: "identity", emotions: ["content", "confident"], weight: .moderate),
                      ContextEmotionPair(context: "finances", emotions: ["happy", "satisfied"], weight: .moderate),
                      ContextEmotionPair(context: "politics", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "weather", emotions: ["happy", "peaceful"], weight: .moderate),
                      ContextEmotionPair(context: "work", emotions: ["indifferent", "hopeful"], weight: .slight)
                     ]),
        .init(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextEmotionPair(context: "family", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "health", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "identity", emotions: ["happy"], weight: .slight),
                      ContextEmotionPair(context: "finances", emotions: ["calm", "satisfied"], weight: .moderate),
                      ContextEmotionPair(context: "politics", emotions: ["anxious"], weight: .slight),
                      ContextEmotionPair(context: "weather", emotions: ["sad", "disappointed"], weight: .moderate),
                      ContextEmotionPair(context: "work", emotions: ["indifferent"], weight: .slight)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextEmotionPair(context: "behavior", emotions: ["happy"], weight: .extreme),
                      ContextEmotionPair(context: "health", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "identity", emotions: ["happy", "confident"], weight: .moderate),
                      ContextEmotionPair(context: "finances", emotions: ["excited"], weight: .slight),
                      ContextEmotionPair(context: "politics", emotions: ["nervous"], weight: .moderate),
                      ContextEmotionPair(context: "weather", emotions: ["calm"], weight: .slight),
                      ContextEmotionPair(context: "work", emotions: ["angry", "disappointed"], weight: .moderate)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextEmotionPair(context: "hobbies", emotions: ["happy"], weight: .extreme),
                      ContextEmotionPair(context: "finances", emotions: ["happy", "excited"], weight: .none)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextEmotionPair(context: "family", emotions: ["happy", "indifferent"], weight: .slight),
                      ContextEmotionPair(context: "health", emotions: ["calm"], weight: .extreme),
                      ContextEmotionPair(context: "hobbies", emotions: ["excited"], weight: .moderate),
                      ContextEmotionPair(context: "identity", emotions: ["content", "confident"], weight: .moderate),
                      ContextEmotionPair(context: "finances", emotions: ["happy", "satisfied"], weight: .none),
                      ContextEmotionPair(context: "politics", emotions: ["indifferent"], weight: .slight),
                      ContextEmotionPair(context: "social", emotions: ["lonely", "lost"], weight: .none),
                      ContextEmotionPair(context: "weather", emotions: ["happy", "peaceful"], weight: .moderate),
                      ContextEmotionPair(context: "work", emotions: ["indifferent", "hopeful"], weight: .extreme)
                     ]
             )
    ]
}
