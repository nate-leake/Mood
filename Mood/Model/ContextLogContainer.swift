//
//  ContextMoodPair.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation

/// The intensity of the emotion ranging from 0-3
enum Weight : Int, Codable, Hashable, CaseIterable {
    case none = 0
    case slight = 1
    case moderate = 2
    case extreme = 3
}

class MoodLogContainer: ObservableObject, Codable {
    @Published var moodName: String
    @Published var emotions: [String]
    @Published var weight: Weight
    
    // Coding keys to conform to Codable
    private enum CodingKeys: String, CodingKey {
        case mood
        case emotions
        case weight
    }
    
    // Conform to Decodable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        emotions = try values.decode([String].self, forKey: .emotions)
        weight = try values.decode(Weight.self, forKey: .weight)
        do {
            moodName = try values.decode(String.self, forKey: .mood)
        } catch {
            moodName = ""
            if let name = Emotion(name: emotions[0]).getParentMood()?.name{
                moodName = name
            } else {
                print("no mood name could be determined for CEP. The moodName property for this pair will be left empty.")
            }
        }
    }
    
    // Conform to Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(moodName, forKey: .mood)
        try container.encode(emotions, forKey: .emotions)
        try container.encode(weight, forKey: .weight)
    }
    
    init(emotions: [String], weight: Weight) {
        self.moodName = ""
        self.emotions = emotions
        self.weight = weight
        
        if let name = Emotion(name: emotions[0]).getParentMood()?.name {
            self.moodName = name
        }
    }
}

/// Groups the context to the user's emotions and the emotions to an intensity
class ContextLogContainer : ObservableObject, Codable, Hashable {
    @Published var contextId : String
    @Published var contextName: String
    @Published var moodContainers: [MoodLogContainer]
    @Published var totalWeight: Int = 0
    
    // conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(contextId)
    }
    
    // conform to Equatable
    static func ==(lhs: ContextLogContainer, rhs: ContextLogContainer) -> Bool {
        return lhs.contextId == rhs.contextId
    }
    
    // Coding keys to conform to Codable
    private enum CodingKeys: String, CodingKey {
        case context
        case moodContainers
    }
    
    // Conform to Decodable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decode(String.self, forKey: .context)
        contextId = id
        if let context = UnsecureContext.getContext(from: id) {
            contextName = context.name
        } else {
            print("a context with the id \(id) has not been loaded in the DS. The name property for this pair will be left empty.")
            contextName = ""
        }
        
        moodContainers = try values.decode([MoodLogContainer].self, forKey: .moodContainers)
        
        for container in moodContainers {
            self.totalWeight += container.weight.rawValue
        }
    }
    
    // Conform to Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contextId, forKey: .context)
        try container.encode(moodContainers, forKey: .moodContainers)
    }
    
    /// Create a ContextLogContainer using [String] for the emotions rather than [Emotion]
    /// - Parameters:
    ///   - context: A String of the context to provide with the emotion
    ///   - emotions: A list of emotions that the user feels as a String
    ///   - weight: The intesnity of the emotions
    init(contextId: String, emotions: [String], weight: Weight) {
        self.contextId = contextId
        self.contextName = UnsecureContext.getContext(from: contextId)?.name ?? "unknown name"
        self.moodContainers = []
        self.moodContainers.append(MoodLogContainer(emotions: emotions, weight: weight))
        self.totalWeight += weight.rawValue
    }
    
    /// Create a ContextLogContainer using [Emotion] for the emotions rather than [String]
    /// - Parameters:
    ///   - context:A String of the context to provide with the emotion
    ///   - emotions: A list of emotions that the user feels as an Emotion
    ///   - weight: The intesnity of the emotions
    init(contextId: String, emotions: [Emotion], weight: Weight) {
        self.contextId = contextId
        self.contextName = UnsecureContext.getContext(from: contextId)!.name
        
        var emotionNames: [String] = []
        
        for emotion in emotions {
            emotionNames.append(emotion.name)
        }
        self.moodContainers = []
        self.moodContainers.append(MoodLogContainer(emotions: emotionNames, weight: weight))
        self.totalWeight += weight.rawValue
    }
    
    init(contextId: String, moodLogContainers: [MoodLogContainer]) {
        self.contextId = contextId
        self.contextName = UnsecureContext.getContext(from: contextId)?.name ?? "unknown name"
        self.moodContainers = moodLogContainers
        for container in moodLogContainers {
            self.totalWeight += container.weight.rawValue
        }
    }
    
    /// Adds a MoodLogContainer to ContextLogContainer using [String] for the emotions rather than [Emotion]
    /// - Parameters:
    ///   - emotions: A list of emotions that the user feels as a String
    ///   - weight: The intesnity of the emotions
    func addContextContainer(emotions: [String], weight: Weight) {
        self.moodContainers.append(MoodLogContainer(emotions: emotions, weight: weight))
    }
    
    /// Adds a MoodLogContainer to ContextLogContainer using [Emotion] for the emotions rather than [String]
    /// - Parameters:
    ///   - emotions: A list of emotions that the user feels as an Emotion
    ///   - weight: The intesnity of the emotions
    func addContextContainer(emotions: [Emotion], weight: Weight){
        var emotionNames: [String] = []
        
        for emotion in emotions {
            emotionNames.append(emotion.name)
        }
        self.moodContainers.append(MoodLogContainer(emotions: emotionNames, weight: weight))
    }
}

