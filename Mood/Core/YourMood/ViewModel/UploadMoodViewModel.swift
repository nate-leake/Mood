//
//  UploadMoodViewModel.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import Foundation
import SwiftUI
import Firebase

class UploadMoodViewModel: ObservableObject {
    private var dailyData: DailyData = DailyData(date: Date(), timeZoneOffset: TimeZone.current.secondsFromGMT(for: Date()), pairs: [])
    @Published var pairs: [ContextEmotionPair] = []
    
    func containsPair(withContext contextName: String) -> Bool {
        return pairs.contains { $0.contextName == contextName }
    }
    
    func addPair(_ pair: ContextEmotionPair) {
        pairs.append(pair)
        // Since pairs is @Published, SwiftUI will now reactively update
    }
    
    @MainActor
    func uploadMoodPost() async throws -> Bool {
        for pair in pairs {
            print("pair to upload: \(pair.contextName) with emotions \(pair.emotions) and weight \(pair.weight.rawValue)")
            self.dailyData.addPair(pair: pair)
        }
        
        let uploaded = try await DailyDataService.shared.uploadMood(dailyData: self.dailyData)
        if uploaded {
            DailyDataService.shared.userHasLoggedToday = true
            return true
        } else {
            print("Something went wrong uploading mood post!")
            return false
        }
    }
}
