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
    
    init(date: Date, timeZoneOffset: Int, pairs: [ContextLogContainer]) {
        self.date = date
        self.contextLogContainers = pairs
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
    static var MOCK_DATA : [DailyData] = [
        .init(date: Date(), timeZoneOffset: TZO,
              pairs: [ContextLogContainer(contextId: "CA88ABD8-270B-44F9-BEDE-5311B660CB77", emotions: ["happy", "indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "045E60F1-103D-4D1D-A15D-1DA7B0FDF8E1", emotions: ["calm"], weight: .none),
                      ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["happy", "satisfied"], weight: .moderate),
                      ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["happy", "peaceful"], weight: .extreme),
                      ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", emotions: ["indifferent", "hopeful"], weight: .slight)
                     ]),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", emotions: ["indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "045E60F1-103D-4D1D-A15D-1DA7B0FDF8E1", emotions: ["calm"], weight: .moderate),
                      ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["happy"], weight: .slight),
                      ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["calm", "satisfied"], weight: .moderate),
                      ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["anxious"], weight: .slight),
                      ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["sad", "disappointed"], weight: .moderate),
                      ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", emotions: ["indifferent"], weight: .slight)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", emotions: ["happy"], weight: .extreme),
                      ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["happy", "confident"], weight: .moderate),
                      ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["excited"], weight: .slight),
                      ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "3C1A36C1-1897-4D16-A1BB-8B50E12772EC", emotions: ["angry", "disappointed"], weight: .moderate)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", emotions: ["happy", "indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["calm"], weight: .slight),
                      ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["content", "confident"], weight: .moderate),
                      ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["happy", "satisfied"], weight: .moderate),
                      ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["happy", "peaceful"], weight: .moderate),
                      ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", emotions: ["indifferent", "hopeful"], weight: .slight)
                     ]),
        .init(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", emotions: ["indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["happy"], weight: .slight),
                      ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["calm", "satisfied"], weight: .moderate),
                      ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["anxious"], weight: .slight),
                      ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["sad", "disappointed"], weight: .moderate),
                      ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", emotions: ["indifferent"], weight: .slight)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextLogContainer(contextId: "CA88ABD8-270B-44F9-BEDE-5311B660CB77", emotions: ["happy"], weight: .extreme),
                      ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["happy", "confident"], weight: .moderate),
                      ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["excited"], weight: .slight),
                      ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["nervous"], weight: .moderate),
                      ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["calm"], weight: .slight),
                      ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", emotions: ["angry", "disappointed"], weight: .moderate)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextLogContainer(contextId: "045E60F1-103D-4D1D-A15D-1DA7B0FDF8E1", emotions: ["happy"], weight: .extreme),
                      ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["happy", "excited"], weight: .none)
                     ]
             ),
        .init(date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, timeZoneOffset: TZO,
              pairs: [ContextLogContainer(contextId: "68B3089C-0E4A-4D36-A1D3-ED075E1722B7", emotions: ["happy", "indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "846530A7-0D95-4BA3-83D7-E1ECC2E5F152", emotions: ["calm"], weight: .extreme),
                      ContextLogContainer(contextId: "045E60F1-103D-4D1D-A15D-1DA7B0FDF8E1", emotions: ["excited"], weight: .moderate),
                      ContextLogContainer(contextId: "26AADCEF-0E06-421B-8D5E-12031B851D4D", emotions: ["content", "confident"], weight: .moderate),
                      ContextLogContainer(contextId: "3594A955-4CC1-4F18-9143-6902ACB8187E", emotions: ["happy", "satisfied"], weight: .none),
                      ContextLogContainer(contextId: "D9DCDC1D-8E57-4937-8877-DD7BA364BC72", emotions: ["indifferent"], weight: .slight),
                      ContextLogContainer(contextId: "3C1A36C1-1897-4D16-A1BB-8B50E12772EC", emotions: ["lonely", "lost"], weight: .none),
                      ContextLogContainer(contextId: "4854C8B2-B7B8-43B4-8A3C-276B3D334206", emotions: ["happy", "peaceful"], weight: .moderate),
                      ContextLogContainer(contextId: "FE0FF895-DEE0-4226-B4A9-4CA74B663DA7", emotions: ["indifferent", "hopeful"], weight: .extreme)
                     ]
             )
    ]
}
