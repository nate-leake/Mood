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

struct ContextMoodPair {
    var context : String
    var moods : [String]
    var weight: Weight
    
    init(context: String, moods: [String], weight: Weight) {
        self.context = context
        self.moods = moods
        self.weight = weight
    }
}

