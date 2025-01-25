//
//  UploadMoodViewModel.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import Foundation
import SwiftUI
import Firebase
import Combine

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
    @Published private(set) var allSubmittable: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        self.observeObjects()
    }
    
    private func observeObjects() {
        cancellables.removeAll() // Reset existing subscriptions
        formViewModels.forEach { observeObject($0) }
        updateAllSubmittable()
    }
    
    private func observeObject(_ object: MoodFormViewModel) {
        object.$selectedEmotions
            .receive(on: RunLoop.main) // Ensure updates happen on the main thread
            .sink { [weak self] _ in
                self?.updateAllSubmittable()
            }
            .store(in: &cancellables)
    }
    
    private func updateAllSubmittable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            withAnimation(.easeInOut(duration: 0.25)){
                if self.formViewModels.isEmpty {
                    self.allSubmittable = false
                } else {
                    self.allSubmittable = self.formViewModels.allSatisfy { !$0.selectedEmotions.isEmpty }
                }
            }
        }
        
    }
    
    func resetFormViewModels() {
        self.takenMoods = []
        self.formViewModels = [MoodFormViewModel()]
    }
    
    func addFormViewModel(){
        let newFVM = MoodFormViewModel()
        self.formViewModels.append(newFVM)
        observeObject(newFVM)
        updateAllSubmittable()
    }
    
    func deleteFormViewModel(removing form: MoodFormViewModel) {
        self.formViewModels.removeAll(where: { $0.id == form.id } )
        updateAllSubmittable()
        if let mood = form.selectedMood?.name {
            self.takenMoods.removeAll(where: { $0.name == mood } )
        }
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
    
    func createPairsFromFormViewModels(contextID: String, moodFormManager: MoodFormManager) {
        for form in moodFormManager.formViewModels {
            let cEP = ContextEmotionPair(contextId: contextID, emotions: form.selectedEmotions, weight: form.weight)
            self.addPair(cEP)
            moodFormManager.resetFormViewModels()
        }
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
