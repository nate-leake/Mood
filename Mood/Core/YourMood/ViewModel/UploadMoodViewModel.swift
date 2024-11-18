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
    @Published var isUploaded: Bool = false
    
    func containsPair(withContextId contextId: String) -> Bool {
        return pairs.contains { $0.contextId == contextId }
    }
    
    func addPair(_ pair: ContextEmotionPair) {
        pairs.append(pair)
        // Since pairs is @Published, SwiftUI will now reactively update
    }
    
    @MainActor
    func uploadMoodPost() async throws -> Bool {
        
        for pair in pairs{
            dailyData.addPair(pair: pair)
        }
        
        let uploaded = try await DataService.shared.uploadMoodPost(dailyData: self.dailyData)
        if uploaded {
            DataService.shared.userHasLoggedToday = true
            isUploaded = true
            return true
        } else {
            print("Something went wrong uploading mood post!")
            isUploaded = false
            return false
        }
    }
}
