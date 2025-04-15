//
//  Objective.swift
//  Mood
//
//  Created by Nate Leake on 4/5/25.
//

import Foundation
import SwiftUI

struct SecureObjective: Identifiable, Hashable, Codable {
    let id: String
    var data: Data?
    
    init(from objective: UnsecureObjective) {
        self.id = objective.id
        
        let dataToEncrypt: [String:String] = [
            "title": objective.title,
            "description": objective.description,
            "colorHex": objective.colorHex,
            "isCompleted": objective.isCompleted.description
        ]
        
        
        do {
            self.data = try SecurityService().encryptData(from: dataToEncrypt)
        } catch {
            print("could not encrypt data in SecureObjective: \(error.localizedDescription)")
        }
    }
}

class UnsecureObjective: Codable, Identifiable, ObservableObject {
    var id: String
    @Published var title: String
    @Published var description: String
    @Published var colorHex: String
    @Published var color: Color
    @Published var isCompleted: Bool
    
    init(from secureObjective: SecureObjective) {
        self.id = secureObjective.id
        self.title = ""
        self.description = ""
        self.colorHex = Color.appPurple.toHex()!
        self.color = Color.appPurple
        self.isCompleted = false
        
        do {
            if let encyrptedData = secureObjective.data{
                let decryptedData:[String:String] = try SecurityService().decryptData(encyrptedData)
                self.title = decryptedData["title"] ?? ""
                self.description = decryptedData["description"] ?? ""
                let colorHex = decryptedData["colorHex"] ?? ""
                self.colorHex = colorHex
                self.color = Color(hex: colorHex)
                let isCompletedStringRepresentation = decryptedData["isCompleted"] ?? "false"
                if let stringToBool = Bool(isCompletedStringRepresentation) {
                    self.isCompleted = stringToBool
                } else {
                    print("error converting String to Bool in UnsecureObjective init(from: SecureObjective). '\(isCompletedStringRepresentation)' is not a valid Boolean. self.isCompleted will be set to false")
                    self.isCompleted = false
                }
                
            }
        } catch {
            print("error converting SecureContext to UnsecureContext: \(error.localizedDescription)")
        }
        
    }
    
    init(title: String, description: String, color: Color, isCompleted: Bool = false) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.color = color
        self.colorHex = color.toHex()!
        self.isCompleted = isCompleted
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, colorHex, isCompleted
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        
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
    
    static func getObjective(from id: String) -> UnsecureObjective? {
        if !DataService.shared.loadedObjectives.isEmpty{
            return DataService.shared.loadedObjectives.first(where: {$0.id == id})
        } else {
            return nil
        }
    }
    
    static let MOCK_DATA: [UnsecureObjective] = [
        .init(title: "meet more people", description: "this objective is to meet more people", color: .red),
        .init(title: "use CBT", description: "this objective is to use CBT", color: .blue),
        .init(title: "find more hobbies", description: "this objective is to find more hobbies", color: .orange),
        .init(title: "try new foods", description: "this objective is to try new foods", color: .mint),
        .init(title: "self care", description: "this objective is to self care", color: .indigo),
        .init(title: "speak up", description: "this objective is to speak up", color: .green),
        .init(title: "face your fears", description: "this objective is to face your fears", color: .teal)
    ]
    
}
