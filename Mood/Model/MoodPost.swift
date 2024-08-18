//
//  MoodPost.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import Foundation
import Firebase

/// A structure for holding information that relates to one of the contexts. It provides the "path" to the emotion by storing the moodType. This is used for loading the database back into the app and displaying it properly.
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


/// A wrapper for DailyData that gets uploaded to the database. The extra data that is added is used
struct MoodPost: Identifiable, Hashable, Codable {
    let id: String
    var timestamp: Date
    var timeZoneOffset: Int
    var data: [ContextEmotionPair]
    
    
    /// Reformats the DailyData object and wraps it with other information to be uploaded to the database
    /// - Parameters:
    ///   - id: The unique ID to be used for the MoodPost
    ///   - data: The DailyData that should be included in the post
    init(id: String, data: DailyData) {
        self.id = id
        self.timestamp = data.date
        self.timeZoneOffset = data.timeZoneOffset
        
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
