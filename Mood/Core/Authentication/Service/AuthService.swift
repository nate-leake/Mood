//
//  AuthService.swift
//  Mood
//
//  Created by Nate Leake on 9/14/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

class AuthService: Stateable {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var userIsSignedIn: Bool?
    @Published var state: AppStateCase = .startup
    
    static let shared = AuthService()
    
    init(){
        AppState.shared.addContributor(adding: self)
        Task {try await loadUserData()}
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
        } catch {
            print("DEBUG: Failed to log in with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(email:String, password: String, name: String, birthday: Date) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            await self.uploaduserData(uid: result.user.uid, email: email, name: name, birthday: birthday)
        } catch {
            print("DEBUG: Failed to register user with error: \(error.localizedDescription)")
        }
    }
    
    /// Loads data about the user's profile only
    @MainActor
    func loadUserData() async throws{
        self.state = .loading
        self.userSession = Auth.auth().currentUser
        guard let currentUid = self.userSession?.uid else {
            self.userIsSignedIn = false
            self.state = .ready
            DailyDataService.shared.refreshServiceData()
            return
        }
        let snapshot = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
        self.currentUser = try? snapshot.data(as: User.self)
        self.userIsSignedIn = true
        self.state = .ready
        DailyDataService.shared.refreshServiceData()
        print("done loading user data")
    }
    
    func signout(){
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
    
    @MainActor
    private func uploaduserData(uid: String, email: String, name: String, birthday: Date) async {
        let user = User(email: email, name: name, birthday: birthday)
        self.currentUser = user
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {return}
        try? await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
    }
}
