//
//  JSONDecoder.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation
import SwiftUI

class Mood: Codable {
    var name: String
    var emotions: [Emotion]
    
    init(name: String, emotions: [Emotion]) {
        self.name = name
        self.emotions = emotions
    }
    
    func getColor() -> Color {
        return Color(self.name)
    }
    
    static let allMoods: [Mood] = Bundle.main.decode(file: "moods.json")
    static let sampleMood: Mood = allMoods[0]
}


class Emotion: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}


extension Bundle {
    func decode<T: Decodable>(file:String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the porject")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) in the project")
        }
        
        return loadedData
    }
}
