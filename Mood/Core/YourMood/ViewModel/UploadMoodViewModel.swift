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
    @Published var dailyData: DailyData = DailyData(date: Date(), pairs: [])
    
    func uploadMood() async throws{
        print("DEBUG: uploading mood post...")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let dailyPostRef = Firestore.firestore().collection("dailyPosts").document()
        let privatePostRef = Firestore.firestore().collection("users").document(uid).collection("posts").document()
        
        let dailyPost = MoodPost(id: dailyPostRef.documentID, data: self.dailyData)
        let privatePost = MoodPost(id: uid, data: self.dailyData)

        guard let encodedDailyPost = try? Firestore.Encoder().encode(dailyPost) else {return}
        guard let encodedPrivatePost = try? Firestore.Encoder().encode(privatePost) else {return}
        
        try await dailyPostRef.setData(encodedDailyPost)
        try await privatePostRef.setData(encodedPrivatePost)
        print("DEBUG: post uploaded.")
    }
}
