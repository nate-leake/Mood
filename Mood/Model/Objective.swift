//
//  Objective.swift
//  Mood
//
//  Created by Nate Leake on 4/5/25.
//

import Foundation
import SwiftUI

class Objective: Codable, Identifiable, ObservableObject {
    var id: String
    @Published var title: String
    @Published var description: String
    @Published var colorHex: String
    @Published var color: Color
    
    init(title: String, description: String, color: Color) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.color = color
        self.colorHex = color.toHex()!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, colorHex
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        let hex = try container.decode(String.self, forKey: .colorHex)
        color = Color(hex: hex)
        colorHex = hex
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
    }
    
    static let MOCK_DATA: [Objective] = [
        .init(title: "meet more people", description: "this objective is to meet more people", color: .red),
        .init(title: "use CBT", description: "this objective is to use CBT", color: .blue),
        .init(title: "find more hobbies", description: "this objective is to find more hobbies", color: .orange),
        .init(title: "try new foods", description: "this objective is to try new foods", color: .mint),
        .init(title: "self care", description: "this objective is to self care", color: .indigo),
        .init(title: "speak up", description: "this objective is to speak up", color: .green),
        .init(title: "face your fears", description: "this objective is to face your fears", color: .teal)
    ]
    
}
