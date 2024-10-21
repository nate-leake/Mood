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
    
    func provideAuthErrorDescription(from error: any Error) -> String{
        var errorMessage = ""
        if let authError = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: authError.code) {
            // Switch on errorCode to detect specific errors
            switch errorCode {
            case .emailAlreadyInUse:
                errorMessage = "the email address is already in use"
            case .invalidEmail:
                errorMessage = "the email address is not valid"
            case .missingEmail:
                errorMessage = "an email address is required"
            case .weakPassword:
                errorMessage = "the password is too weak"
            case .wrongPassword:
                errorMessage = "the email or password is incorrect"
            case .networkError:
                errorMessage = "a network error occurred"
            case .userNotFound:
                errorMessage = "no user found with this email"
            case .tooManyRequests:
                errorMessage = "there are too many requests, please try again later"
            case .invalidCredential:
                errorMessage = "the email or password is incorrect"
            case .internalError:
                errorMessage = "an error occurred. please check your email and password and try again"
            default:
                errorMessage = "\(authError.localizedDescription.lowercased())"
            }
        } else {
            // Handle any other unknown error
            errorMessage = "we're sorry, an error occured.\n if this issue persists, please submit a bug report in TestFlight with this error message:\n\(error.localizedDescription.lowercased())"
        }
        return errorMessage
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws -> String {
        var errorMessage = ""
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            errorMessage = try await loadUserData()
        } catch {
            print("DEBUG: Failed to log in with error: \(error.localizedDescription)\nDetails: \(error)")
            errorMessage = provideAuthErrorDescription(from: error)
        }
        return errorMessage
    }
    
    @MainActor
    func createUser(email:String, password: String, name: String, birthday: Date, userPin: String) async throws -> String {
        var errorMessage: String = ""
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            await self.uploaduserData(uid: result.user.uid, email: email, name: name, birthday: birthday, userPin: userPin)
        } catch {
            // Attempt to cast error to `AuthErrorCode` type to handle specific Firebase errors
            errorMessage = provideAuthErrorDescription(from: error)
        }
        return errorMessage
    }
    
    /// Loads data about the user's profile only
    @MainActor
    func loadUserData() async throws -> String {
        var errorMessage = ""
        self.state = .loading
        self.userSession = Auth.auth().currentUser
        guard let currentUid = self.userSession?.uid else {
            withAnimation(animation){
                self.isUnlocked = true
                self.userIsSignedIn = false
                self.state = .ready
            }
            DataService.shared.refreshServiceData()
            errorMessage = "no user is signed in"
            return errorMessage
        }
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
            withAnimation(animation){
                self.currentUser = try? snapshot.data(as: User.self)
                self.userIsSignedIn = true
                self.state = .ready
            }
            DataService.shared.refreshServiceData()
        } catch {
            errorMessage = provideAuthErrorDescription(from: error)
        }
        
        print("done loading user data")
        
        return errorMessage
    }
    
    @MainActor
    private func uploaduserData(uid: String, email: String, name: String, birthday: Date, userPin: String) async {
        var encryptedPin: Data
        do {
            encryptedPin = try SecurityService().encryptData(from: userPin)
            let user = User(email: email, name: name, birthday: birthday, pin: encryptedPin)
            guard let encodedUser = try? Firestore.Encoder().encode(user) else {return}
            try? await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
            withAnimation(animation){
                self.currentUser = user
                self.userIsSignedIn = true
                self.isUnlocked = true
                self.state = .ready
            }
        } catch {
            print("error uploading user data: \(error)")
        }
    }
    
    private func validatePin(using pin: String) -> Bool {
        var isValidPin: Bool = false
        if let uid = self.userSession?.uid{
            // allows apple review account to bypass pin verification since encryption key is stored in iCloud Keychain
            if uid == "L4cyLrYmqrbfpZHQwCIBlFNrOBK2" {
                return true
            }
        }
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
