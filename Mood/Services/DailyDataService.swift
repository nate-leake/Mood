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
    @Published var logWindowOpen: Bool = false
    @Published var todaysDailyData: DailyData?
    
    static let shared = DailyDataService()
    
    let dateFormatter = CustomDateFormatter()
    
    init(){
        Task {
            try await getLoggedToday()
        }
    }
    
    /// Uploads the user's DailyData wrapped in a MoodPost to the database
    /// - Parameter dailyData: The DailyData object to be uploaded
    /// - Returns: The success or failure of the upload represented as a true or false boolean
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
    
    func fetchDocuments(limit: Int) async throws -> QuerySnapshot{
        print("DEBUG: fetching documents...")
        
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let userDocument = Firestore.firestore().collection("users").document(uid)
        let userPostsCollection = userDocument.collection("posts")
        let query = userPostsCollection.order(by: "timestamp", descending: true).limit(to: limit)
        
        print("DEBUG: fetched documents.")
        
        return try await query.getDocuments()
        
    }
    
    @MainActor
    func fetchLastLoggedMoodPost() async throws -> MoodPost? {
        let snapshot = try await fetchDocuments(limit: 1)
        var post: MoodPost?
        
        if snapshot.count > 0 {
            post = try snapshot.documents[0].data(as: MoodPost.self)
            if let p = post{
                self.todaysDailyData = DailyData(date: p.timestamp, timeZoneOffset: p.timeZoneOffset, pairs: p.data)
            }
        }
        
        return post
    }
    
    func fetchLastLoggedDate() async throws -> [String: Any]? {
        print("DEBUG: fetching last logged date...")
        
        var lastLoggedDate: [String: Any]?
        
        let post = try await fetchLastLoggedMoodPost()
        
        if let p = post {
            lastLoggedDate = ["logDate": p.timestamp,
                              "timezoneOffset": p.timeZoneOffset]
            print("DEBUG: fetched last logged date")
            print(lastLoggedDate ?? "No last log date retreived")
        }
        
        return lastLoggedDate
    }
    
    @MainActor
    func getLoggedToday() async throws{
        let fetchedDate: [String: Any]? = try await fetchLastLoggedDate()
        let logDate = fetchedDate?["logDate"] as? Timestamp ?? Timestamp()
        let lastLogDate = logDate.dateValue()
        let lastOffset = fetchedDate?["timezoneOffset"] as? Int ?? 0
        
        let now = Date()
        let currentOffset = TimeZone.current.secondsFromGMT(for: now)
        
        // Adjust last log date to the current timezone
        let adjustedLastLogDate = lastLogDate.addingTimeInterval(TimeInterval(currentOffset - lastOffset))
        
        // Get the current time and compare
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let logWindowStart = calendar.date(byAdding: .hour, value: 19, to: startOfToday)!
        
        print(adjustedLastLogDate, ">=", logWindowStart, "&&", adjustedLastLogDate, "<", now)
        
        // Check if the log window has oponed
        if now >= logWindowStart{
            self.logWindowOpen = true
        }
        
        
        // Check if last log is within today’s window
        if adjustedLastLogDate >= logWindowStart && adjustedLastLogDate < now {
            print("Has logged today")
            self.userHasLoggedToday = true  // Already logged today
        } else {
            print("Did not log yet")
            self.userHasLoggedToday = false   // Can log today
        }
        
    }
    
    
    
}
