//
//  DailyDataService.swift
//  Mood
//
//  Created by Nate Leake on 10/17/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

enum CustomError: Error {
    case invalidUID
    case firestoreEncoding
}

extension Date
{
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
}

class CustomDateFormatter{
    private var formatter = DateFormatter()
    
    init(){
        self.formatter.dateFormat = "yyyy-MM-dd@HH:mm:ss"
    }
    
    func string(from: Date) -> String {
        return formatter.string(from: from)
    }
    
    func date(from: String) -> Date? {
        return formatter.date(from: from)
    }
}

class DailyDataService : ObservableObject{
    @Published var userHasLoggedToday: Bool = false
    
    static let shared = DailyDataService()
    
    let dateFormatter = CustomDateFormatter()
    
    init(){
        Task {
            try await getLoggedToday()
        }
    }
    
    @MainActor
    func uploadMood(dailyData: DailyData) async throws -> Bool {
        print("DEBUG: uploading mood post...")
        var uploadSuccess = false
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        print(dateFormatter.string(from: dailyData.date))
        let dailyPostRef = Firestore.firestore().collection("dailyPosts").document()
        let privatePostRef = Firestore.firestore().collection("users").document(uid).collection("posts").document(dateFormatter.string(from: dailyData.date))
        
        let dailyPost = MoodPost(id: dailyPostRef.documentID, data: dailyData)
        let privatePost = MoodPost(id: uid, data: dailyData)
        
        guard let encodedDailyPost = try? Firestore.Encoder().encode(dailyPost) else {throw CustomError.firestoreEncoding}
        guard let encodedPrivatePost = try? Firestore.Encoder().encode(privatePost) else {throw CustomError.firestoreEncoding}
        
        do {
            try await dailyPostRef.setData(encodedDailyPost)
            try await privatePostRef.setData(encodedPrivatePost)
            uploadSuccess = true
            print("DEBUG: uploaded mood post")
        } catch {
            print("DEBUG: failed to upload mood post")
        }
        
        return uploadSuccess
    }
    
    // this function will fetch a specified number of documents and return them as an array
    func fetchDocuments(limit: Int) async throws -> QuerySnapshot{
        print("DEBUG: fetching documents...")
        
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let userDocument = Firestore.firestore().collection("users").document(uid)
        let userPostsCollection = userDocument.collection("posts")
        let query = userPostsCollection.order(by: "timestamp", descending: true).limit(to: limit)
        
        print("DEBUG: fetched documents.")
        
        return try await query.getDocuments()
        
    }
    
    // move some functionality to get all documents to fetchDocuments
    // use fetchDocuments as await function call?
    // process this returned element as .data(MoodPost.self) and get its timestamp
    func fetchLastLoggedDate() async throws -> Date? {
        print("DEBUG: fetching last logged...")
        
        var lastLoggedDate: Date?
        
        let snapshot = try await fetchDocuments(limit: 1)
        
        if snapshot.count > 0 {
            let document = snapshot.documents[0]
            
            print("zeroth index: \(try document.data(as: MoodPost.self))")
            
            lastLoggedDate = try document.data(as: MoodPost.self).timestamp
            
            print("DEBUG: fetched last logged.")
        }
        
        return lastLoggedDate
    }
    
    @MainActor
    func getLoggedToday() async throws{
        let fetchedDate: Date? = try await fetchLastLoggedDate()
        
        if let date = fetchedDate {
            print("Date collected! \(date)")
            print(Date())
            print(Date().get(.day).day ?? "no day")
            if let getDay = date.get(.day).day {
                if let currentDay = Date().get(.day).day {
                    if getDay < currentDay {
                        print("has not logged today")
                        self.userHasLoggedToday = false
                    } else {
                        print("has logged today")
                        self.userHasLoggedToday = true
                    }
                }
            }
        } else {
            print("Date not collected")
        }
    }
    
}
