//
//  MoodPost.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import Foundation
import Firebase

/// A structure for holding information that relates to one of the contexts. It provides the "path" to the emotion by storing the moodType. This is used for loading the database back into the app and displaying it properly.
struct MoodData: Hashable, Codable, Identifiable {
    var id: String
    var date: Date
    var context: String
    var moodType: String
    var intensity: Int
    
    init(date: Date, context: String, moodType: String, intensity: Int) {
        self.id = NSUUID().uuidString
        self.date = date
        self.context = context
        self.moodType = moodType
        self.intensity = intensity
    }
}
extension MoodData {
    static var MOCK_DATA : [MoodData] = [
        .init(date: Date.now, context: "family", moodType: "happiness", intensity: 2),
        .init(date: Date.now, context: "health", moodType: "sadness", intensity: 1),
        .init(date: Date.now, context: "identity", moodType: "fearful", intensity: 1),
        .init(date: Date.now, context: "money", moodType: "anger", intensity: 3),
        .init(date: Date.now, context: "politics", moodType: "neutrality", intensity: 0),
        .init(date: Date.now, context: "weather", moodType: "sadness", intensity: 1),
        .init(date: Date.now, context: "work", moodType: "happy", intensity: 1)
    ]
}


/// A wrapper for DailyData that gets uploaded to the database. The extra data that is added is used to track log time.
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
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[3]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[4]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[5]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[6]
             )
    ]
}
