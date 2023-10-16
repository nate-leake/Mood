//
//  ContextMoodPair.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation

enum Weight : Int, Codable {
    case none = 0
    case slight = 1
    case moderate = 2
    case extreme = 3
}

class ContextEmotionPair : ObservableObject, Codable {
    @Published var context : String
    @Published var emotions : [String]
    @Published var weight: Weight
    
    // Coding keys to conform to Codable
    private enum CodingKeys: String, CodingKey {
        case context
        case emotions
        case weight
    }
    
    // Conform to Decodable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        context = try values.decode(String.self, forKey: .context)
        emotions = try values.decode([String].self, forKey: .emotions)
        weight = try values.decode(Weight.self, forKey: .weight)
    }
    
    // Conform to Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(context, forKey: .context)
        try container.encode(emotions, forKey: .emotions)
        try container.encode(weight, forKey: .weight)
    }
    
    init(context: String, emotions: [String], weight: Weight) {
        self.context = context
        self.emotions = emotions
        self.weight = weight
    }
    
    init(context: String, emotions: [Emotion], weight: Weight) {
        self.context = context
        self.emotions = []
        self.weight = weight
        
        for emotion in emotions {
            self.emotions.append(emotion.name)
        }
    }
}

