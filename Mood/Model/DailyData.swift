//
//  DailyData.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import Foundation


/// Stores the ContextEmotionPairs from the user's log for that day
class DailyData: Codable, Hashable{
    var date: Date
    var timeZoneOffset: Int
    var contextLogContainers: [ContextLogContainer]
    
    // conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
    
    // conform to Equatable
    static func ==(lhs: DailyData, rhs: DailyData) -> Bool {
        return lhs.date == rhs.date
    }
    
    init(date: Date, timeZoneOffset: Int, contextLogContainers: [ContextLogContainer]) {
        self.date = date
        self.contextLogContainers = contextLogContainers
        self.timeZoneOffset = timeZoneOffset
    }
    
    func addContextLogContainer(contextLogContainer: ContextLogContainer){
        self.contextLogContainers.append(contextLogContainer)
    }
    
    func getContextLogContainer(withContextId: String) -> ContextLogContainer? {
        var matchedPair: ContextLogContainer?
        for p in contextLogContainers {
            if p.contextId == withContextId{
                matchedPair = p
            }
        }
        
        return matchedPair
    }
    
    func containsContextLogContainer(withContextId contextId: String) -> Bool {
        // Check logic to return the correct result.
        print("daily data result for \(contextId):", contextLogContainers.contains { $0.contextId == contextId })
        return contextLogContainers.contains { $0.contextId == contextId }
    }
}

extension DailyData {
    static var TZO = TimeZone.current.secondsFromGMT(for: Date())
    
    static func randomData(count: Int) -> [DailyData]{
        var data: [DailyData] = []
        
        // create the number of DailyData needed and add them to data
        for i in 0...count {
            var logContainers: [ContextLogContainer] = []
            
            // random number of ContextLogContainer to be added to logContainers
            let contextLogCount = Int.random(in: 1...UnsecureContext.defaultContexts.count-1)
            
            // list all available indexes of the context ids
            var availableContextIdx: [Int] = []
            for int in 0...UnsecureContext.defaultContexts.count-1 {
                availableContextIdx.append(int)
            }
            
            // create the number of ContextLogContainers needed and add them to logContainers
            for _ in 0...contextLogCount {
                let randomContextIdx = availableContextIdx.randomElement()!
                availableContextIdx.removeAll{ $0 == randomContextIdx }
                
                let cid = UnsecureContext.defaultContexts[randomContextIdx].id
                
                var moodLogContainers: [MoodLogContainer] = []
                
                // random number of MoodLogContainers to be added to moodLogContainers
                let moodLogCount = Int.random(in: 1...Mood.allMoodNames.count-1)
                
                var availableMoods = Mood.allMoods
                
                
                for _ in 0...moodLogCount {
                    
                    let randomMood = Mood.allMoods.randomElement()!
                    availableMoods.removeAll { $0.name == randomMood.name}
                    
                    let emotions: [String] = [randomMood.emotions.randomElement()!.name]
                    let weight: Weight = Weight.allCases.randomElement()!
                    
                    moodLogContainers.append( MoodLogContainer(emotions: emotions, weight: weight) )
                    
                }
                
                
                let newLogContainer = ContextLogContainer(contextId: cid, moodLogContainers: moodLogContainers)
                
                logContainers.append(newLogContainer)
            }
            
            let newData = DailyData(
                date: Calendar.current.date(byAdding: .day, value: -i, to: Date())!, timeZoneOffset: TZO,
                contextLogContainers: logContainers
            )
            
            data.append(newData)
        }
        
        
        return data
    }
    
    static var MOCK_DATA : [DailyData] = [
        .init(date: Date(), timeZoneOffset: TZO,
              contextLogContainers: [
                ContextLogContainer(contextId: "CA88ABD8-270B-44F9-BEDE-5311B660CB77", moodLogContainers: [
                    MoodLogContainer(emotions: ["indifferent"], weight: .slight),
                    MoodLogContainer(emotions: ["happy"], weight: .slight)
                ]),
                ContextLogContainer(contextId: "045E60F1-103D-4D1D-A15D-1DA7B0FDF8E1", emotions: ["calm"], weight: .none),
                ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["happy", "satisfied"], weight: .moderate),
                ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["happy", "peaceful"], weight: .extreme),
                ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", moodLogContainers: [
                    MoodLogContainer(emotions: ["hopeful"], weight: .slight),
                    MoodLogContainer(emotions: ["indifferent"], weight: .slight)
                ])
              ]),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, timeZoneOffset: TZO,
              contextLogContainers: [
                ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", moodLogContainers: [
                    MoodLogContainer(emotions: ["indifferent"], weight: .slight),
                    MoodLogContainer(emotions: ["angry"], weight: .slight)
                ]),
                ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["indifferent"], weight: .slight),
                ContextLogContainer(contextId: "045E60F1-103D-4D1D-A15D-1DA7B0FDF8E1", emotions: ["calm"], weight: .moderate),
                ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["happy"], weight: .slight),
                ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", moodLogContainers: [
                    MoodLogContainer(emotions: ["satisfied", "happy"], weight: .moderate),
                    MoodLogContainer(emotions: ["calm"], weight: .moderate)
                ]),
                ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["anxious"], weight: .slight),
                ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["sad", "disappointed", "withdrawn"], weight: .moderate),
                ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", emotions: ["indifferent"], weight: .slight)
              ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, timeZoneOffset: TZO,
              contextLogContainers: [
                ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", emotions: ["happy"], weight: .extreme),
                ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["happy", "confident"], weight: .moderate),
                ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["excited"], weight: .slight),
                ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["indifferent"], weight: .slight),
                ContextLogContainer(contextId: "3C1A36C1-1897-4D16-A1BB-8B50E12772EC", moodLogContainers: [
                    MoodLogContainer(emotions: ["disappointed"], weight: .moderate),
                    MoodLogContainer(emotions: ["angry"], weight: .moderate)
                ])
              ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, timeZoneOffset: TZO,
              contextLogContainers: [
                ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", moodLogContainers: [
                    MoodLogContainer(emotions: ["indifferent"], weight: .slight),
                    MoodLogContainer(emotions: ["happy"], weight: .slight)
                ]),
                ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["calm"], weight: .slight),
                ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", moodLogContainers: [
                    MoodLogContainer(emotions: ["confident"], weight: .moderate),
                    MoodLogContainer(emotions: ["content"], weight: .moderate)
                ]),
                ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["happy", "satisfied"], weight: .moderate),
                ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["indifferent"], weight: .slight),
                ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["happy", "peaceful"], weight: .moderate),
                ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", moodLogContainers: [
                    MoodLogContainer(emotions: ["indifferent"], weight: .slight),
                    MoodLogContainer(emotions: ["hopeful"], weight: .slight)
                ])
              ]),
        .init(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, timeZoneOffset: TZO,
              contextLogContainers: [
                ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", emotions: ["indifferent"], weight: .slight),
                ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["indifferent"], weight: .slight),
                ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["happy"], weight: .slight),
                ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", moodLogContainers: [
                    MoodLogContainer(emotions: ["satisfied"], weight: .moderate),
                    MoodLogContainer(emotions: ["calm"], weight: .moderate)
                ]),
                ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["anxious"], weight: .slight),
                ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["sad", "disappointed"], weight: .moderate),
                ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", emotions: ["indifferent"], weight: .slight)
              ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, timeZoneOffset: TZO,
              contextLogContainers: [
                ContextLogContainer(contextId: "CA88ABD8-270B-44F9-BEDE-5311B660CB77", emotions: ["happy"], weight: .extreme),
                ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["indifferent"], weight: .slight),
                ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["happy", "confident"], weight: .moderate),
                ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["excited"], weight: .slight),
                ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["nervous"], weight: .moderate),
                ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["calm"], weight: .slight),
                ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", moodLogContainers: [
                    MoodLogContainer(emotions: ["angry"], weight: .moderate),
                    MoodLogContainer(emotions: ["disappointed"], weight: .moderate)
                ])
              ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, timeZoneOffset: TZO,
              contextLogContainers: [
                ContextLogContainer(contextId: "045E60F1-103D-4D1D-A15D-1DA7B0FDF8E1", emotions: ["happy"], weight: .extreme),
                ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["happy", "excited"], weight: .none)
              ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, timeZoneOffset: TZO,
              contextLogContainers: [
                ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", moodLogContainers: [
                    MoodLogContainer(emotions: ["happy"], weight: .slight),
                    MoodLogContainer(emotions: ["indifferent"], weight: .slight)
                ]),
                ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["calm"], weight: .extreme),
                ContextLogContainer(contextId: "045E60F1-103D-4D1D-A15D-1DA7B0FDF8E1", emotions: ["excited"], weight: .moderate),
                ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", moodLogContainers: [
                    MoodLogContainer(emotions: ["content"], weight: .moderate),
                    MoodLogContainer(emotions: ["worried"], weight: .slight)
                ]),
                ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["happy", "satisfied"], weight: .none),
                ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["indifferent"], weight: .slight),
                ContextLogContainer(contextId: "3C1A36C1-1897-4D16-A1BB-8B50E12772EC", emotions: ["lonely", "lost"], weight: .none),
                ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["happy", "peaceful"], weight: .moderate),
                ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", moodLogContainers: [
                    MoodLogContainer(emotions: ["hopeful"], weight: .extreme),
                    MoodLogContainer(emotions: ["indifferent"], weight: .extreme)
                ])
              ]
             )
    ]
}
