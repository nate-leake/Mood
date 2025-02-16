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
    private var dailyData: DailyData = DailyData(date: Date(), timeZoneOffset: TimeZone.current.secondsFromGMT(for: Date()), contextLogContainers: [])
    @Published var contextLogContainers: [ContextLogContainer] = []
    @Published var isUploaded: Bool = false
    
    
    func containsContextLogContainer(withContextId contextId: String) -> Bool {
        return contextLogContainers.contains { $0.contextId == contextId }
    }
    
    private func addContextLogContainer(_ contextLogContainer: ContextLogContainer) {
        contextLogContainers.append(contextLogContainer)
        // Since pairs is @Published, SwiftUI will now reactively update
    }
    
    func createContextLogContainersFromFormViewModels(contextID: String, moodFormManager: MoodFormManager) {
        print("creating pairs...")
        for form in moodFormManager.formViewModels {
            if let container = contextLogContainers.first(where: {$0.contextId == contextID}) {
                print("adding to container")
                container.addContextContainer(emotions: form.selectedEmotions, weight: form.weight)
            } else {
                let CLC = ContextLogContainer(contextId: contextID, emotions: form.selectedEmotions, weight: form.weight)
                self.addContextLogContainer(CLC)
                print("CEP added for CID \(contextID) with emotions \(form.selectedEmotions)")
                moodFormManager.resetFormViewModels()
            }
            
        }
    }
    
    @MainActor
    func uploadMoodPost() async throws -> Bool {
        
        for logContainer in contextLogContainers{
            print("adding pair \(logContainer) to daily data")
            dailyData.addContextLogContainer(contextLogContainer: logContainer)
        }
        
        for logContainer in dailyData.contextLogContainers {
            print("daily data recorded: \(logContainer.contextId) with \(dailyData.contextLogContainers.count)")
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
