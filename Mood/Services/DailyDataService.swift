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

/// The DailyDataService is responsable for handling the user's daily logs
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
    
    /// Loads the number of posts the user has made over all time
    /// - Returns: An Int of the user's post count
    func getNumberOfEntries() async throws -> Int {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let userDocument = Firestore.firestore().collection("users").document(uid)
        let userPostsCollection = userDocument.collection("posts")
        
        let snapshot = try await userPostsCollection.count.getAggregation(source: .server)
        print("user has \(Int(truncating: snapshot.count)) entries")
        return Int(truncating: snapshot.count)
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
        } catch {
        }
        
        return uploadSuccess
    }
    
    /// Gets a certain number of documents from the users "posts" collection
    /// - Parameter limit: The number of post documents to retreive
    /// - Returns: QuerySnapshot of the posts
    func fetchDocuments(limit: Int) async throws -> QuerySnapshot{
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let userDocument = Firestore.firestore().collection("users").document(uid)
        let userPostsCollection = userDocument.collection("posts")
        let query = userPostsCollection.order(by: "timestamp", descending: true).limit(to: limit)
                
        return try await query.getDocuments()
    }
    
    /// Gets the last mood post that the user uploaded
    /// - Returns: An Optional MoodPost which will be the most recent post from the user
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
    
    /// Derives the date and timezone offset from the last logged MoodPost
    /// - Returns: A dictionary containing the logDate and the timezoneOffset
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
    
    /// Checks if the user has logged today or not and sets the DailyDataService.userHasLoggedToday
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
        // Potential bug in this logic. The last log does not need to be within the current day's
        // window due to timezone changes and it is also not the objective of this line of code.
        // The starting window needs to be less than the current dateTime and the last log date
        // shouldn't share the same date as the current date
        if adjustedLastLogDate >= logWindowStart && adjustedLastLogDate < now {
            print("Has logged today")
            self.userHasLoggedToday = true  // Already logged today
        } else {
            print("Did not log yet")
            self.userHasLoggedToday = false   // Can log today
        }
        
    }
    
    
    
}
