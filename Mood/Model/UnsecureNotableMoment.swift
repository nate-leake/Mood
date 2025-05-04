//
//  NotableMoment.swift
//  Mood
//
//  Created by Nate Leake on 5/2/25.
//

import Foundation

struct SecureNotableMoment: Identifiable, Hashable, Codable {
    let id: String
    var date: Date
    var data: Data?
    
    init(from moment: UnsecureNotableMoment) {
        self.id = moment.id
        self.date = moment.date
        
        let dataToEncrypt: [String:String] = [
            "title": moment.title,
            "description": moment.description,
            "pleasureSelection": moment.pleasureSelection.rawValue
        ]
        
        
        do {
            self.data = try SecurityService().encryptData(from: dataToEncrypt)
        } catch {
            print("could not encrypt data in SecureObjective: \(error.localizedDescription)")
        }
    }
}

class UnsecureNotableMoment: ObservableObject, Identifiable, Codable {
    let id: String
    @Published var title: String
    @Published var description: String
    @Published var date: Date
    @Published var pleasureSelection: PleasureScale
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, date, pleasureSelection
    }
    
    init(id: String = UUID().uuidString, title: String, description: String, date: Date, pleasureSelection: PleasureScale) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.pleasureSelection = pleasureSelection
    }
    
    init(from secureMoment: SecureNotableMoment) {
        self.id = secureMoment.id
        self.date = secureMoment.date
        self.title = "title"
        self.description = "description"
        self.pleasureSelection = .uncertainty
        
        do {
            if let encyrptedData = secureMoment.data {
                let decryptedData:[String:String] = try SecurityService().decryptData(encyrptedData)
                self.title = decryptedData["title"] ?? ""
                self.description = decryptedData["description"] ?? ""
                let decryptedPleasureSelection = decryptedData["pleasureSelection"] ?? ""
                self.pleasureSelection = PleasureScale(rawValue: decryptedPleasureSelection) ?? .uncertainty
            }
        } catch {
            print("error converting SecureNotableMoment to UnsecureNotableMoment: \(error.localizedDescription)")
        }
    }
    
    // custom implimentation to Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        date = try container.decode(Date.self, forKey: .date)
        pleasureSelection = try container.decode(PleasureScale.self, forKey: .pleasureSelection)
    }
    
    // custom implimentation to Decodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(date, forKey: .date)
        try container.encode(pleasureSelection, forKey: .pleasureSelection)
    }
    
    static func getMoment(from id: String) -> UnsecureNotableMoment? {
        if !DataService.shared.loadedMoments.isEmpty{
            return DataService.shared.loadedMoments.first(where: {$0.id == id})
        } else {
            return nil
        }
    }
    
    public static var MOCK_DATA: [UnsecureNotableMoment] = [
        .init(title: "definition", description: "A defining moment in your life is an occasion where your life’s path has undeniably changed.", date: Date.now, pleasureSelection: .uncertainty),
        .init(title: "more defining", description: "It could be something that changes within yourself. Maybe you experience an injury or illness that changes your perspective in life.", date: Date.now, pleasureSelection: .pleasure),
        .init(title: "even more of it", description: "It could be an external factor like a career or relationship change.", date: Date.now, pleasureSelection: .pleasure),
        .init(title: "things could be different", description: "But a defining moment is one of those times that you know you’ll look back on and say “If it weren’t for that, things would be different.”", date: Date.now, pleasureSelection: .displeasure),
        .init(title: "info", description: "As you go on your own path, you undoubtedly will have similar defining moments.  In fact, I’m sure you already have. Sometimes it just takes a while to realize how important these moments are.", date: Date.now, pleasureSelection: .uncertainty),
        .init(title: "Examples", description: "Examples include Getting married or divorced, Starting a new job or leaving an old one, Beginning a new business partnership, Taking a big trip, Paying off debt, Finishing school, Retiring, Losing a Loved One, Having a baby", date: Date.now, pleasureSelection: .displeasure),
    ]
}
