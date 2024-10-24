//
//  Context.swift
//  Mood
//
//  Created by Nate Leake on 9/19/24.
//

import Foundation
import SwiftUI

class Context: Codable, Hashable, Identifiable, ObservableObject {
    var id: String
    @Published var name: String
    @Published var iconName: String
    @Published var colorHex: String
    @Published var color: Color
//    @Published var isHidden: Bool
    
    init(name: String, iconName: String, colorHex: String) {
        self.id = UUID().uuidString
        self.name = name
        self.iconName = iconName
        self.colorHex = colorHex
        self.color = Color(hex: colorHex)
//        self.isHidden = false
    }
    
    init(id: String, name: String, iconName: String, color: Color) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.colorHex = color.toHex() ?? "#9BA0FA"
        self.color = color
//        self.isHidden = isHidden
    }
    
    static func getContext(from id: String) -> Context? {
        return DataService.shared.loadedContexts.first(where: {$0.id == id})
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, iconName, colorHex, isHidden
    }
    
    // custom implimentation to Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        iconName = try container.decode(String.self, forKey: .iconName)
        let hex = try container.decode(String.self, forKey: .colorHex)
        colorHex = hex
        color = Color(hex: hex)
//        isHidden = try container.decode(Bool.self, forKey: .isHidden)
    }
    
    // custom implimentation to Decodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(iconName, forKey: .iconName)
        try container.encode(colorHex, forKey: .colorHex)
//        try container.encode(isHidden, forKey: .isHidden)
    }
    
    // conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // confrom to Equatable
    static func ==(lhs: Context, rhs: Context) -> Bool {
        return lhs.name == rhs.name && lhs.iconName == rhs.iconName
    }
    
    static let defaultContexts: [Context] = Bundle.main.decode(file: "contexts.json")
}
