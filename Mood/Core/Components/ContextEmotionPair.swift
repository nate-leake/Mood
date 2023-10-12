//
//  ContextMoodPair.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation

enum Weight : Int {
    case none = 0
    case slight = 1
    case moderate = 2
    case extreme = 3
}

class ContextEmotionPair : ObservableObject {
    @Published var context : String
    @Published var emotions : [String]
    @Published var weight: Weight
    
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

