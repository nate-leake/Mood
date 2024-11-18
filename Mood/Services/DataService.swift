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
class DataService : ObservableObject, Stateable {
    @Published var userHasLoggedToday: Bool = false
    @Published var logWindowOpen: Bool = false
    @Published var todaysDailyData: DailyData?
    @Published var recentMoodPosts: [UnsecureMoodPost]?
    @Published var numberOfEntries: Int = 0
    @Published var state: AppStateCase = .startup
    @Published var loadedContexts: [UnsecureContext] = []
    public var isPerformingManagedAGUpdate: Bool = false
    
    static let shared = DataService()
    
    let securityService = SecurityService()
    let dateFormatter = CustomDateFormatter()
    
    private func cp(_ text: String, state: PrintableStates = .none) {
        let finalString = "💿\(state.rawValue) DATA SERVICE: " + text
        print(finalString)
    }
    
    private func updateAG(){
        if !self.isPerformingManagedAGUpdate {
            AnalyticsGenerator.shared.calculateTBI(dataService: self)
        }
    }
    
    init(){
        AppState.shared.addContributor(adding: self)
        self.state = .loading
    }
    
    @MainActor
    func refreshServiceData(){
        if let signedIn = AuthService.shared.userIsSignedIn {
            if signedIn {
                self.state = .loading
                cp("refreshing...")
                Task {
                    try await fetchContexts()
                    try await getLoggedToday()
                    try await setRecentMoodPosts(quantity: 7)
                    try await getNumberOfEntries()
                    if self.userHasLoggedToday { self.updateAG() }
                    if recentMoodPosts != nil {
                        await MainActor.run {
                            withAnimation(.easeInOut(duration: 2)){
                                state = .ready
                            }
                        }
                    }
                }
            } else {
                self.state = .ready
            }
        }
        
    }
    
    @MainActor
    private func uploadData(document: DocumentReference, uploadData: Encodable) async -> Result<Bool, Error> {
        do {
            let encodedUpload = try Firestore.Encoder().encode(uploadData)
            
            try await document.setData(encodedUpload)
            self.updateAG()
            
            // Call completion with success
            return .success(true)
        } catch {
            // Call completion with failure and error
            return .failure(error)
        }
    }
    
    // MARK: - custom contexts section
    
    @MainActor
    func fetchContexts() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let userDocument = Firestore.firestore().collection("users").document(uid)
        let contextCollection = userDocument.collection("contexts")
        let query = contextCollection
        
        let documents = try await query.getDocuments().documents
        
        self.loadedContexts = []
        
        for document in documents {
            var optionalContext: SecureContext?
            do {
                optionalContext = try document.data(as: SecureContext.self)
                
                if let secureContext = optionalContext {
                    let unsecureContext = UnsecureContext(from: secureContext)
                    self.loadedContexts.append(unsecureContext)
                } else {
                    cp("secure context was not found")
                }
            } catch {
                cp("error loading data from document: \(error.localizedDescription)")
            }
        }
        
        self.loadedContexts.sort { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    @MainActor
    func uploadContext(context: UnsecureContext) async throws -> Result<Bool, Error> {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let docRef = Firestore.firestore().collection("users").document(uid).collection("contexts").document(context.id)
        
        let encryptedContext = SecureContext(from: context)
        
        let res = await uploadData(document: docRef, uploadData: encryptedContext)
        
        switch res {
        case .success(let success):
            if success {
                self.loadedContexts.append(context)
                self.loadedContexts.sort { $0.name.lowercased() < $1.name.lowercased() }
            }
        case .failure(let error):
            cp("error uploading context: \(error)")
        }
        
        return res
    }
    
    @MainActor
    func updateContext(to context: UnsecureContext) async throws -> Result<Bool, Error> {
//        cp(try Firestore.Encoder().encode(context))
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let docRef = Firestore.firestore().collection("users").document(uid).collection("contexts").document(context.id)
        
        let foundContext = UnsecureContext.getContext(from: context.id)
        
        if context.name != foundContext?.name {
            foundContext?.name = context.name
        }
        if context.colorHex != foundContext?.colorHex {
            foundContext?.colorHex = context.colorHex
            foundContext?.color = context.color
        }
        if context.iconName != foundContext?.iconName {
            foundContext?.iconName = context.iconName
        }
        if context.isHidden != foundContext?.isHidden {
            foundContext?.isHidden = context.isHidden
        }
        if context.associatedPostIDs != foundContext?.associatedPostIDs {
            foundContext?.associatedPostIDs = context.associatedPostIDs
        }
        
        let encryptedContext = SecureContext(from: context)
        
        let result = await uploadData(document: docRef, uploadData: encryptedContext)

        self.loadedContexts.sort { $0.name.lowercased() < $1.name.lowercased() }
        return result
    }
    
    func deleteContext(context: UnsecureContext) async throws {
        cp("beginning delete for context \(context.id)")
        self.isPerformingManagedAGUpdate = true
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        let contextDocRef = Firestore.firestore().collection("users").document(uid).collection("contexts").document(context.id)
        var completedDeletes = 0
        
        cp("attempting to fetch \(context.associatedPostIDs.count) posts related to this context")
        for postID in context.associatedPostIDs {
//            cp("getting post with id: \(postID)")
            if var post = try await fetchMoodPost(withID: postID) {
//                cp("getting deletable pairs...")
                var deletablePairs: [Int] = []
                for pair in post.data {
                    if pair.contextId == context.id {
                        if let index = post.data.firstIndex(of: pair){
                            deletablePairs.append(index)
//                            cp("added deletable pair")
                        }
                    }
                }
                
                deletablePairs.sort{$0 > $1}
                
//                cp("post has \(post.data.count) pairs")
                for index in deletablePairs {
//                    cp("deleting pair at index \(index): \(post.data[index].contextName)")
                    post.data.remove(at: index)
                }
//                cp("post now has \(post.data.count) pairs", state: post.data.count==0 ? .warning : .none)
                if post.data.count == 0 {
                    cp("post should be auto deleted when it has 0 pairs.", state: .warning)
                }
                
                try await updatePost(with: post)
                
            } else {
                cp("no post with that ID was found", state: .error)
            }
            completedDeletes += 1
            print("\(completedDeletes*100 / context.associatedPostIDs.count)% complete...")
        }
        
        do {
            try await contextDocRef.delete()
            cp("deleted firebase context doc", state: .debug)
        } catch {
            cp("error deleting context: \(error)", state: .error)
        }
        
        self.isPerformingManagedAGUpdate = false
        await self.refreshServiceData()
        cp("finished delete for context \(context.id)")
    }
    
    
    // MARK: - mood data section
    
    /// Uploads the user's DailyData wrapped in a MoodPost to the database
    /// - Parameter dailyData: The DailyData object to be uploaded
    /// - Returns: The success or failure of the upload represented as a true or false boolean
    @MainActor
    func uploadMoodPost(dailyData: DailyData) async throws -> Bool {
        cp("uploading mood post...")
        var uploadSuccess = false
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let privatePostRef = Firestore.firestore().collection("users").document(uid).collection("posts").document()
        
        let privatePost = SecureMoodPost(id: privatePostRef.documentID, data: dailyData)
        
        if privatePost.data != nil{
            
            let result = await uploadData(document: privatePostRef, uploadData: privatePost)
            
            switch result {
            case .success(let success):
                if success {
                    DataService.shared.todaysDailyData = dailyData
                    if DataService.shared.recentMoodPosts?.count ?? 0 > 0 {
                        DataService.shared.recentMoodPosts?.removeFirst()
                    }
                    DataService.shared.recentMoodPosts?.append(UnsecureMoodPost(from: privatePost))
                    DataService.shared.numberOfEntries += 1
                    for pair in dailyData.pairs {
                        if let c = UnsecureContext.getContext(from: pair.contextId) {
                            let updatedContext = UnsecureContext(id: c.id, name: c.name, iconName: c.iconName, color: c.color, isHidden: c.isHidden, associatedPostIDs: c.associatedPostIDs)
                            updatedContext.associatedPostIDs.append(privatePost.id)
                            let result = try await updateContext(to: updatedContext)
                            
                            switch result {
                            case .success(let updateSuccess):
                                if updateSuccess {
                                    uploadSuccess = true
                                }
                            case .failure(let error):
                                cp("an error occured while updating the post's context associatedPostIDs: \(error)")
                                uploadSuccess = false
                            }
                        }
                    }
                }
            case .failure(let error):
                cp("an error occured while uploading the post: \(error)")
                uploadSuccess = false
                
            }
            
        } else {
            uploadSuccess = false
        }
        
        return uploadSuccess
    }
    
    func updatePost(with newPost: UnsecureMoodPost) async throws {
        cp("updating post \(newPost.id)...")
        
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let docRef = Firestore.firestore().collection("users").document(uid).collection("posts").document(newPost.id)
        
        let encryptedUpdate = SecureMoodPost(from: newPost)
        
        let result = await uploadData(document: docRef, uploadData: encryptedUpdate)
        
        switch result {
        case .success(let success):
            if success {
                cp("updated post!")
            }
        case .failure(let error):
            cp("error updating post: \(error)")
        }
        
    }
    
    func deleteMoodPost(postID: String) async throws -> Result<Bool, Error> {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        let userDocument = Firestore.firestore().collection("users").document(uid)
        let userPostsCollection = userDocument.collection("posts")
        let docRef = userPostsCollection.document(postID)
        
        if let moodPost = try await fetchMoodPost(withID: postID) {
            for pair in moodPost.data {
                if let context = UnsecureContext.getContext(from: pair.contextId){
                    
                    var associatedPostIDs = context.associatedPostIDs
                    
                    if let index = associatedPostIDs.firstIndex(of: postID){
                        associatedPostIDs.remove(at: index)
                        let updatedContext = UnsecureContext(id: context.id, name: context.name, iconName: context.iconName, color: context.color, isHidden: context.isHidden, associatedPostIDs: associatedPostIDs)
                        let result = try await self.updateContext(to: updatedContext)
                        
                        switch result {
                        case .success(_):
                            continue
                        case .failure(let error):
                            cp("error updating context: \(error.localizedDescription)")
                        }
                    }
                }
                
            }
        }
        
        do {
            try await docRef.delete()
        } catch {
            cp("an error occured while deleting post \(postID): \(error)")
        }
        
        return .success(true)
    }
    
    func fetchMoodPost(withID postID: String) async throws -> UnsecureMoodPost? {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let userDocument = Firestore.firestore().collection("users").document(uid)
        let userPostsCollection = userDocument.collection("posts")
        var moodPost: UnsecureMoodPost?
        
        let query = userPostsCollection.whereField("id", isEqualTo: postID)
        
        let querySnapshot = try await query.getDocuments()
        
        if querySnapshot.documents.count > 1 {
            cp("error fetching document with id \(postID) as mutliple posts share this ID.")
        } else if querySnapshot.documents.count == 0 {
            cp("no documents were found with id \(postID)", state: .error)
        } else if querySnapshot.documents.count == 1{
            let securePost = try querySnapshot.documents[0].data(as: SecureMoodPost.self)
            moodPost = UnsecureMoodPost(from: securePost)
        }
        
        return moodPost
    }
    
    /// Loads the number of posts the user has made over all time
    /// - Returns: An Int of the user's post count
    @MainActor
    func getNumberOfEntries() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.invalidUID}
        
        let userDocument = Firestore.firestore().collection("users").document(uid)
        let userPostsCollection = userDocument.collection("posts")
        
        let snapshot = try await userPostsCollection.count.getAggregation(source: .server)
        cp("user has \(Int(truncating: snapshot.count)) entries")
        self.numberOfEntries = Int(truncating: snapshot.count)
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
            cp("DATA SERVICE _WARNING_: One or more posts in firebase firestore is not encrypted.")
        }
        
        return filteredPosts
    }
    
    
    /// Derives the date and timezone offset from the last logged MoodPost
    /// - Returns: A dictionary containing the logDate and the timezoneOffset
    func fetchLastLoggedDate() async throws -> [String: Any]? {
        cp("fetching last logged date...")
        
        var lastLoggedDate: [String: Any]?
        
        let post = try await fetchLastLoggedMoodPost()
        
        if let p = post {
            lastLoggedDate = ["logDate": p.timestamp,
                              "timezoneOffset": p.timeZoneOffset]
            cp("fetched last logged date")
        } else {
            cp("could not get the last logged date.")
        }
        
        return lastLoggedDate
    }
    
    /// Checks if the user has logged today or not and sets the DailyDataService.userHasLoggedToday
    @MainActor
    func getLoggedToday() async throws{
        let now = Date.now
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let logWindowStart = calendar.date(byAdding: .hour, value: 19, to: startOfToday)!
        
        let queryDate: [String: Any]? = try await fetchLastLoggedDate()
        // Check if the result for fetchedLastLoggedDate is nil. If if is nil, the user may not have any data in the db
        // and therefore has not logged today.
        if let fetchedDate = queryDate {
            let logDate = fetchedDate["logDate"] as? Date ?? Date()
            
            // *******************************************************************************
            // UNLUESS THERE IS A CONFIRMED BUG WITH THE LINES BELOW THIS STATEMENT, DO NOT ALTER THIS CODE
            // This took me so long and so many tries to get right.
            // This code works by getting the start of the last log date
            // We then compare that start of the day to the start of the current day
            // If they are the same day, the user already logged
            // If they are not the same day then the user has not logged (or the user time traveled)
            // This is a LOT less convoluted than the code I spent hours writing
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
        } else {
            self.userHasLoggedToday = false
        }
        
        // Check if the log window has oponed
        if now >= logWindowStart{
            self.logWindowOpen = true
        }
        
        cp("user has logged: \(self.userHasLoggedToday)")
        cp("log window open: \(self.logWindowOpen)")
        
    }
}
