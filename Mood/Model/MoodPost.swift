//
//  MoodPost.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import Foundation
import Firebase

struct MoodData: Hashable, Codable {
    let id: String
    let context: String
    let moodType: String
    let emotion: String
    let intensity: Int
}
extension MoodData {
    static var MOCK_DATA : [MoodData] = [
        .init(id: NSUUID().uuidString, context: "family", moodType: "happiness", emotion: "happy", intensity: 2),
        .init(id: NSUUID().uuidString, context: "health", moodType: "sadness", emotion: "hopeless", intensity: 1),
        .init(id: NSUUID().uuidString, context: "identity", moodType: "fearful", emotion: "stressed", intensity: 1),
        .init(id: NSUUID().uuidString, context: "money", moodType: "anger", emotion: "furious", intensity: 3),
        .init(id: NSUUID().uuidString, context: "politics", moodType: "neutrality", emotion: "indifferent", intensity: 0),
        .init(id: NSUUID().uuidString, context: "weather", moodType: "sadness", emotion: "disappointed", intensity: 1),
        .init(id: NSUUID().uuidString, context: "work", moodType: "happy", emotion: "hopeful", intensity: 1)
    ]
}


struct MoodPost: Identifiable, Hashable, Codable {
    let id: String
    var timestamp: Date
    var data: [ContextEmotionPair]
    
    
    init(id: String, data: DailyData) {
        self.id = id
        self.timestamp = data.date
        
        var tmpData: [ContextEmotionPair] = []
        for pair in data.pairs {
            tmpData.append(pair)
        }
        self.data = tmpData
    }
}

extension MoodPost {
    static var MOCK_DATA : [MoodPost] = [
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[0]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[1]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[2]
             )
    ]
}
