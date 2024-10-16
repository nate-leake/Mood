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
import SwiftUI
import LocalAuthentication

class AuthService: Stateable, ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var userIsSignedIn: Bool?
    @Published var isUnlocked: Bool = false
    @Published var state: AppStateCase = .startup
    
    var animation: Animation = .easeInOut
    
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
    func createUser(email:String, password: String, name: String, birthday: Date, userPin: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            await self.uploaduserData(uid: result.user.uid, email: email, name: name, birthday: birthday, userPin: userPin)
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
            withAnimation(.easeInOut){
                self.isUnlocked = true
                self.userIsSignedIn = false
                self.state = .ready
            }
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
    
    @MainActor
    private func uploaduserData(uid: String, email: String, name: String, birthday: Date, userPin: String) async {
        var encryptedPin: Data
        do {
            encryptedPin = try SecurityService().encryptData(from: userPin)
            let user = User(email: email, name: name, birthday: birthday, pin: encryptedPin)
            guard let encodedUser = try? Firestore.Encoder().encode(user) else {return}
            try? await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
            self.currentUser = user
            self.userIsSignedIn = true
            self.isUnlocked = true
            self.state = .ready
        } catch {
            print("error uploading user data: \(error)")
        }
    }
    
    private func validatePin(using pin: String) -> Bool {
        var isValidPin: Bool = false
        if userIsSignedIn == true {
            if let user = currentUser {
                do {
                    let decryptedPin: String = try SecurityService().decryptData(user.pin)
                    if pin == decryptedPin {
                        isValidPin = true
                    }
                } catch {
                    print("error validating pin: \(error)")
                }
            }
        }
        
        return isValidPin
    }
    
    private func authenticateBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "verify your identity to unlock mood"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                success, authenticationError in
                if success {
                    // authenticated succesfully
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    // there was a problem
                    print(authenticationError ?? "error could not be read")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        } else {
            // no biometrics
            print("no biometrics available on this device")
            completion(false)
        }
    }
    
    
    func lock(){
        withAnimation(animation) {
            self.isUnlocked = false
        }
    }
    
    func unlock(using pin: String){
        withAnimation(animation) {
            self.isUnlocked = self.validatePin(using: pin)
        }
    }
    
    func unlock(using pin: String) -> Bool {
        withAnimation(animation) {
            self.isUnlocked = self.validatePin(using: pin)
        }
        return self.isUnlocked
    }
    
    func unlockUsingBiometrics() {
        authenticateBiometrics() { isAuthenticated in
            withAnimation(self.animation) {
                self.isUnlocked = isAuthenticated
            }
        }
    }
    
    func unlockUsingBiometrics(completion: @escaping (Bool) -> Void) {
        authenticateBiometrics() { isAuthenticated in
            withAnimation(self.animation) {
                self.isUnlocked = isAuthenticated
                DispatchQueue.main.async {
                    completion(isAuthenticated)
                }
            }
        }
    }
    
    func signout(){
        try? Auth.auth().signOut()
        withAnimation(animation) {
            self.userSession = nil
            self.currentUser = nil
            self.userIsSignedIn = false
        }
    }
}
