//
//  UploadMoodViewModel.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import Foundation
import SwiftUI
import Firebase

class MoodFormViewModel: ObservableObject, Identifiable {
    let id: String = UUID().uuidString
    @Published var selectedMood: Mood?
    @Published var selectedEmotions: [Emotion] = []
    @Published var weight: Weight = .none
    @Published var isDisclosed: Bool = true

}

class MoodFormManager: ObservableObject {
    @Published var takenMoods: [Mood] = []
    @Published var formViewModels : [MoodFormViewModel] = [MoodFormViewModel()]
    
    func resetFormViewModels() {
        self.takenMoods = []
        self.formViewModels = [MoodFormViewModel()]
    }
    
    func addFormViewModel(){
        self.formViewModels.append(MoodFormViewModel())
    }
}


class UploadMoodViewModel: ObservableObject {
    private var dailyData: DailyData = DailyData(date: Date(), timeZoneOffset: TimeZone.current.secondsFromGMT(for: Date()), pairs: [])
    @Published var pairs: [ContextEmotionPair] = []
    @Published var isUploaded: Bool = false
    
    
    func containsPair(withContextId contextId: String) -> Bool {
        return pairs.contains { $0.contextId == contextId }
    }
    
    private func addPair(_ pair: ContextEmotionPair) {
        pairs.append(pair)
        // Since pairs is @Published, SwiftUI will now reactively update
    }
    
//    func createPairsFromFormViewModels(contextID: String) {
//        for form in formViewModels {
//            let cEP = ContextEmotionPair(contextId: contextID, emotions: form.selectedEmotions, weight: form.weight)
//            self.addPair(cEP)
//            self.formViewModels = [MoodFormViewModel(assignedMoods: assignedMoods)]
//        }
//    }
    

    
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
