//
//  Context.swift
//  Mood
//
//  Created by Nate Leake on 9/19/24.
//

import Foundation
import SwiftUI

struct SecureContext: Identifiable, Hashable, Codable {
    let id: String
    let isHidden: Bool
    var associatedPostIDs: Data?
    var data: Data?
    
    init(from context: UnsecureContext){
        self.id = context.id
        self.isHidden = context.isHidden
        let dataToEncrypt: [String:String] = ["name": context.name, "colorHex":context.colorHex, "iconName":context.iconName]
        
        do {
            self.data = try SecurityService().encryptData(from: dataToEncrypt)
            self.associatedPostIDs = try SecurityService().encryptData(from: context.associatedPostIDs)
        } catch {
            print("counld not encrypt data in SecureContext: \(error.localizedDescription)")
        }
    }
    
}

class UnsecureContext: Codable, Hashable, Identifiable, ObservableObject {
    var id: String
    @Published var name: String
    @Published var iconName: String
    @Published var colorHex: String
    @Published var color: Color
    @Published var isHidden: Bool
    @Published var associatedPostIDs: [String]
    @Published var isDeleting: Bool = false
    @Published var percentDeleted = 0
    
    init(from secureContext: SecureContext){
        self.id = secureContext.id
        self.isHidden = secureContext.isHidden
        self.name = ""
        self.iconName = ""
        self.colorHex = Color.appPurple.toHex()!
        self.color = .appPurple
        self.associatedPostIDs = []
        
        do {
            if let encyrptedData = secureContext.data{
                let decryptedData:[String:String] = try SecurityService().decryptData(encyrptedData)
                self.name = decryptedData["name"] ?? ""
                self.iconName = decryptedData["iconName"] ?? ""
                let colorHex = decryptedData["colorHex"] ?? ""
                self.colorHex = colorHex
                self.color = Color(hex: colorHex)
                
            }
        } catch {
            print("error converting SecureContext to UnsecureContext: \(error.localizedDescription)")
        }
        
        do {
            if let encryptedAssociations = secureContext.associatedPostIDs {
                self.associatedPostIDs = try SecurityService().decryptData(encryptedAssociations)
            }
        } catch {
            print("error converting SecureContext to UnsecureContext: \(error.localizedDescription)")
        }
        
    }
    
    init(name: String, iconName: String, colorHex: String) {
        self.id = UUID().uuidString
        self.name = name
        self.iconName = iconName
        self.colorHex = colorHex
        self.color = Color(hex: colorHex)
        self.isHidden = false
        self.associatedPostIDs = []
    }
    
    init(id: String, name: String, iconName: String, color: Color, isHidden: Bool, associatedPostIDs: [String]) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.colorHex = color.toHex() ?? "#9BA0FA"
        self.color = color
        self.isHidden = isHidden
        self.associatedPostIDs = associatedPostIDs
    }
    
    static func getContext(from id: String) -> UnsecureContext? {
        if !DataService.shared.loadedContexts.isEmpty{
            return DataService.shared.loadedContexts.first(where: {$0.id == id})
        } else {
            return self.defaultContexts.first(where: {$0.id == id})
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, iconName, colorHex, isHidden, postIDs
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
        isHidden = try container.decode(Bool.self, forKey: .isHidden)
        do {
            associatedPostIDs = try container.decode([String].self, forKey: .postIDs)
        } catch {
            print("error decoding associatePostIDs: \(error.localizedDescription)")
            associatedPostIDs = []
        }
    }
    
    // custom implimentation to Decodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(iconName, forKey: .iconName)
        try container.encode(colorHex, forKey: .colorHex)
        try container.encode(isHidden, forKey: .isHidden)
        try container.encode(associatedPostIDs, forKey: .postIDs)
    }
    
    // conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // confrom to Equatable
    static func ==(lhs: UnsecureContext, rhs: UnsecureContext) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let defaultContexts: [UnsecureContext] = Bundle.main.decode(file: "contexts.json")
}
