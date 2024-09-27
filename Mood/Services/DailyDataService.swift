//
//  DailyDataService.swift
//  Mood
//
//  Created by Nate Leake on 10/17/23.
//

import Foundation
import SwiftUI
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
    @Published var recentMoodPosts: [UnsecureMoodPost]?
    @MainActor @Published var appIsReady: Bool = false
    
    static let shared = DailyDataService()
    
    let securityService = SecurityService()
    let dateFormatter = CustomDateFormatter()
    
    init(){
        Task {
            try await getLoggedToday()
            try await setRecentMoodPosts(quantity: 7)
            if recentMoodPosts != nil {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 2)){
                        appIsReady = true
                    }
                }
            }
        }
    }
    
    func refreshAppReady(){
        Task {
            print("current recentMoodPosts: \(String(describing: recentMoodPosts))")
            try await getLoggedToday()
            try await setRecentMoodPosts(quantity: 7)
            if recentMoodPosts != nil {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 2)){
                        appIsReady = true
                    }
                }
            }
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
        //        let dailyPostRef = Firestore.firestore().collection("dailyPosts").document()
        let privatePostRef = Firestore.firestore().collection("users").document(uid).collection("posts").document()
        
        //        let dailyPost = MoodPost(id: dailyPostRef.documentID, data: dailyData)
        let privatePost = SecureMoodPost(id: privatePostRef.documentID, data: dailyData)
        
        if privatePost.data != nil{
            
            //        guard let encodedDailyPost = try? Firestore.Encoder().encode(dailyPost) else {throw CustomError.firestoreEncoding}
            guard let encodedPrivatePost = try? Firestore.Encoder().encode(privatePost) else {throw CustomError.firestoreEncoding}
            
            do {
                //            try await dailyPostRef.setData(encodedDailyPost)
                try await privatePostRef.setData(encodedPrivatePost)
                DailyDataService.shared.todaysDailyData = dailyData
                uploadSuccess = true
            } catch {
                print("an error occured while uploading the post: \(error)")
                uploadSuccess = false
            }
            
        } else {
            uploadSuccess = false
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
    func fetchLastLoggedMoodPost() async throws -> UnsecureMoodPost? {
        let snapshot = try await fetchDocuments(limit: 1)
        var securePost: SecureMoodPost?
        var unsecurePost: UnsecureMoodPost?
        
        if snapshot.count > 0 {
            do{
                securePost = try snapshot.documents[0].data(as: SecureMoodPost.self)
                if let post = securePost{
                    unsecurePost = UnsecureMoodPost(from: post)
                    if let up = unsecurePost{
                        self.todaysDailyData = DailyData(date: up.timestamp, timeZoneOffset: up.timeZoneOffset, pairs: up.data)
                    }
                }
            } catch {
                unsecurePost = try snapshot.documents[0].data(as: UnsecureMoodPost.self)
                if let post = unsecurePost{
                    self.todaysDailyData = DailyData(date: post.timestamp, timeZoneOffset: post.timeZoneOffset, pairs: post.data)
                }
            }
        }
        
        return unsecurePost
    }
    
    @MainActor
    private func setRecentMoodPosts(quantity: Int) async throws {
        self.recentMoodPosts = try await fetchRecentMoodPosts(quantity: quantity)
    }
    
    public func fetchRecentMoodPosts(quantity: Int) async throws -> [UnsecureMoodPost] {
        var posts: [UnsecureMoodPost] = []
        let snapshot = try await fetchDocuments(limit: quantity)
        var insecureFlag: Bool = false
        
        if snapshot.count > 0 {
            for document in snapshot.documents {
                do {
                    let securePost = try document.data(as: SecureMoodPost.self)
                    let post = UnsecureMoodPost(from: securePost)
                    posts.append(post)
                } catch {
                    insecureFlag = true
                    let unsecurePost = try document.data(as: UnsecureMoodPost.self)
                    posts.append(unsecurePost)
                }
            }
        } else {
            return []
        }
        
        let cutoffDate = Calendar.current.date(byAdding: .day, value: userHasLoggedToday ? -7 : -8, to: Date())!
        var filteredPosts:[UnsecureMoodPost] = []
        
        for post in posts {
            if Calendar.current.startOfDay(for: post.timestamp) > Calendar.current.startOfDay(for: cutoffDate){
                filteredPosts.append(post)
            }
        }
        
        if insecureFlag {
            print("WARNING: One or more posts in firebase firestore is not encrypted.")
        }
        
        return filteredPosts
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
        } else {
            print("could not get the last logged date.")
        }
        
        return lastLoggedDate
    }
    
    /// Checks if the user has logged today or not and sets the DailyDataService.userHasLoggedToday
    @MainActor
    func getLoggedToday() async throws{
        let fetchedDate: [String: Any]? = try await fetchLastLoggedDate()
        let logDate = fetchedDate?["logDate"] as? Date ?? Date()
        
        let now = Date()
        
        // Get the current time and compare
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let logWindowStart = calendar.date(byAdding: .hour, value: 19, to: startOfToday)!
        
        // Check if the log window has oponed
        if now >= logWindowStart{
            self.logWindowOpen = true
        }
        
        // *******************************************************************************
        // UNLUESS THERE IS A CONFIRMED BUG WITH THE LINES BELOW THIS STATEMENT, DO NOT ALTER THIS CODE
        // This took me so long and so many tries to get right.
        // This code works by getting the start of the last log date
        // We then compare that start of the day to the start of the current day
        // If they are the same day, the user already logged
        // If they are not the same day then the user has not logged (or the user time traveled)
        // This is a LOT less convoluted than the code I spend hours writing
        // NOTE: Apple uses UTC for Date objects and I think Calendar dates are formatted to local time
        
        // Determine if the user has logged today
        let startOfAdjustedLogDay = calendar.startOfDay(for: logDate)
        
        // If the adjusted last log date falls within today’s date range
        if startOfAdjustedLogDay == startOfToday {
            self.userHasLoggedToday = true
        } else {
            self.userHasLoggedToday = false
        }
        
        // DO NOT ALTER THE ABOVE LINES OF CODE!
        // See explination above :)
        
        //        print("User has logged today: \(userHasLoggedToday)")
        //        print("Log window open: \(logWindowOpen)")
        
    }
}
