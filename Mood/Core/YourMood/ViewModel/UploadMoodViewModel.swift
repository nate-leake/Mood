//
//  UploadMoodViewModel.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import Foundation
import SwiftUI
import Firebase

@MainActor
class UploadMoodViewModel: ObservableObject {
    func uploadMood(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let post = MoodPost(id: "", ownerUid: uid, moods: MoodData.MOCK_DATA, timestamp: Date())
    }
}
