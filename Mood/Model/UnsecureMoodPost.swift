//
//  MoodPost.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import Foundation
import Firebase

/// A structure for holding information that relates to one of the contexts. It provides the "path" to the emotion by storing the moodType. This is used for loading the database back into the app and displaying it properly.
struct MoodData: Hashable, Codable, Identifiable {
    var id: String
    var date: Date
    var context: String
    var moodType: String
    var intensity: Int
    
    init(date: Date, contextId: String, moodType: String, intensity: Int) {
        self.id = NSUUID().uuidString
        self.date = date
        self.context = UnsecureContext.getContext(from: contextId)?.name ?? "no context"
        self.moodType = moodType
        self.intensity = intensity
    }
}
extension MoodData {
    static var MOCK_DATA : [MoodData] = [
        .init(date: Date.now, contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", moodType: "happiness", intensity: 2),
        .init(date: Date.now, contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", moodType: "sadness", intensity: 1),
        .init(date: Date.now, contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", moodType: "fearful", intensity: 1),
        .init(date: Date.now, contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", moodType: "anger", intensity: 3),
        .init(date: Date.now, contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", moodType: "neutrality", intensity: 0),
        .init(date: Date.now, contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", moodType: "sadness", intensity: 1),
        .init(date: Date.now, contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", moodType: "happy", intensity: 1)
    ]
}


struct SecureMoodPost: Identifiable, Hashable, Codable {
    let id: String
    var timestamp: Date
    var timeZoneOffset: Int
    var data: Data?
    
    
    /// Reformats the DailyData object and wraps it with other information to be uploaded to the database
    /// - Parameters:
    ///   - id: The unique ID to be used for the MoodPost
    ///   - data: The DailyData that should be included in the post
    init(id: String, data: DailyData) {
        self.id = id
        self.timestamp = data.date
        self.timeZoneOffset = data.timeZoneOffset
        
        var tmpData: [ContextLogContainer] = []
        for pair in data.contextLogContainers {
            tmpData.append(pair)
        }
        
        do {
            self.data = try SecurityService().encryptData(from: tmpData)
        } catch {
            print("could not encrypt data on init of SecureMoodPost: \(error)")
        }
    }
    
    init(from unsecureMoodPost: UnsecureMoodPost) {
        self.id = unsecureMoodPost.id
        self.timestamp = unsecureMoodPost.timestamp
        self.timeZoneOffset = unsecureMoodPost.timeZoneOffset
        
        do {
            self.data = try SecurityService().encryptData(from: unsecureMoodPost.data)
        } catch {
            print("could not encrypt data on init of SecureMoodPost: \(error)")
        }
    }
}


/// A wrapper for DailyData that gets uploaded to the database. The extra data that is added is used to track log time.
struct UnsecureMoodPost: Identifiable, Hashable, Codable {
    let id: String
    var timestamp: Date
    var timeZoneOffset: Int
    var data: [ContextLogContainer]
    
    
    /// Reformats the DailyData object and wraps it with other information to be uploaded to the database
    /// - Parameters:
    ///   - id: The unique ID to be used for the MoodPost
    ///   - data: The DailyData that should be included in the post
    init(id: String, data: DailyData) {
        self.id = id
        self.timestamp = data.date
        self.timeZoneOffset = data.timeZoneOffset
        
        var tmpData: [ContextLogContainer] = []
        for pair in data.contextLogContainers {
            tmpData.append(pair)
        }
        self.data = tmpData
    }
    
    init(from secureMoodPost: SecureMoodPost){
        self.id = secureMoodPost.id
        self.timestamp = secureMoodPost.timestamp
        self.timeZoneOffset = secureMoodPost.timeZoneOffset
        self.data = []
        
        if let postData = secureMoodPost.data{
            do {
                if let decryptedData: [ContextLogContainer] = try SecurityService().decryptData(postData){
                    self.data = decryptedData
                }
            } catch {
                print("error initilizing UnsecureMoodPost from SecureMoodPost: \(error)")
            }
        }
        
    }
}

extension UnsecureMoodPost {
    static var MOCK_DATA : [UnsecureMoodPost] = [
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[0]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[1]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[2]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[3]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[4]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[5]
             ),
        .init(id: NSUUID().uuidString,
              data: DailyData.MOCK_DATA[6]
             )
    ]
}
