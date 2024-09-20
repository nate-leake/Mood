//
//  ContextMoodPair.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation

/// The intensity of the emotion ranging from 0-3
enum Weight : Int, Codable, Hashable {
    case none = 0
    case slight = 1
    case moderate = 2
    case extreme = 3
}

/// Groups the context to the user's emotions and the emotions to an intensity
class ContextEmotionPair : ObservableObject, Codable, Hashable {
    @Published var contextName : String
    @Published var emotions : [String]
    @Published var weight: Weight
    
    // conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(contextName)
    }
    
    // conform to Equatable
    static func ==(lhs: ContextEmotionPair, rhs: ContextEmotionPair) -> Bool {
        return lhs.contextName == rhs.contextName
    }
    
    // Coding keys to conform to Codable
    private enum CodingKeys: String, CodingKey {
        case context
        case emotions
        case weight
    }
    
    // Conform to Decodable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contextName = try values.decode(String.self, forKey: .context)
        emotions = try values.decode([String].self, forKey: .emotions)
        weight = try values.decode(Weight.self, forKey: .weight)
    }
    
    // Conform to Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contextName, forKey: .context)
        try container.encode(emotions, forKey: .emotions)
        try container.encode(weight, forKey: .weight)
    }
    
    /// Create a ContextEmotionPair using [String] for the emotions rather than [Emotion]
    /// - Parameters:
    ///   - context: A String of the context to provide with the emotion
    ///   - emotions: A list of emotions that the user feels as a String
    ///   - weight: The intesnity of the emotions
    init(context: String, emotions: [String], weight: Weight) {
        self.contextName = context
        self.emotions = emotions
        self.weight = weight
    }
    
    /// Create a ContectEmotionPair using [Emotion] for the emotions rather than [String]
    /// - Parameters:
    ///   - context:A String of the context to provide with the emotion
    ///   - emotions: A list of emotions that the user feels as an Emotion
    ///   - weight: The intesnity of the emotions
    init(context: String, emotions: [Emotion], weight: Weight) {
        self.contextName = context
        self.emotions = []
        self.weight = weight
        
        for emotion in emotions {
            self.emotions.append(emotion.name)
        }
    }
}

