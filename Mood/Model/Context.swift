//
//  Context.swift
//  Mood
//
//  Created by Nate Leake on 9/19/24.
//

import Foundation
import SwiftUI

class Context: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var iconName: String
    var colorHex: String
    var color: Color
    
    init(name: String, iconName: String, colorHex: String) {
        self.id = UUID().uuidString
        self.name = name
        self.iconName = iconName
        self.colorHex = colorHex
        self.color = Color(hex: colorHex)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, iconName, colorHex
    }
    
    // custom implimentation to Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        iconName = try container.decode(String.self, forKey: .iconName)
        colorHex = try container.decode(String.self, forKey: .colorHex)
        color = Color(hex: colorHex)
        print("name: \(name), \"id:\" \"\(id)\"")
    }
    
    // custom implimentation to Decodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(iconName, forKey: .iconName)
        try container.encode(colorHex, forKey: .colorHex)
    }
    
    // conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    // confrom to Equatable
    static func ==(lhs: Context, rhs: Context) -> Bool {
        return lhs.name == rhs.name && lhs.iconName == rhs.iconName
    }
    
    static let defaultContexts: [Context] = Bundle.main.decode(file: "contexts.json")
}
