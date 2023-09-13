//
//  JSONDecoder.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation

struct ContextMoodJSON: Decodable {
    let contexts: [String]
    let moods: [String:[String]]
    
    enum RootKeys: String, CodingKey {
        case context, mood, emotion
    }
    
    enum MoodKeys: String, CodingKey {
        case happiness, sadness, fear, anger, neutral
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: RootKeys.self)
        contexts = try values.decode([String].self, forKey: .context)
        moods = try values.decode([String:[String]].self, forKey: .mood)
    }
}
