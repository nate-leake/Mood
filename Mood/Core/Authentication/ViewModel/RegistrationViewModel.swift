//
//  RegistrationViewModel.swift
//  Mood
//
//  Created by Nate Leake on 9/16/23.
//

import Foundation
import FirebaseAuth

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var passwd = ""
    @Published var name = ""
    @Published var birthday = Date.now
    @Published var pin: String = ""
    @Published var signUpWithAppleAuthResult: AuthDataResult?
    @Published var isSigningUpFromSignIn: Bool = false
    
    func setAuthResult(to authResult: AuthDataResult) {
        self.signUpWithAppleAuthResult = authResult
        if let email = authResult.user.email {
            self.email = email
        }
        
        print("RegistrationViewModel is set AuthResult to \(String(describing: self.signUpWithAppleAuthResult))")
    }
    
    func createUser() async throws -> String {
        print(signUpWithAppleAuthResult ?? "no AuthDataResult in RegiVM")
        print(name, birthday, pin)
        if let result = signUpWithAppleAuthResult {
            print("RegistrationViewModel is uploading user account from sign in with Apple")
            return try await AuthService.shared.uploadUserAccount(user: result.user, name: name, birthday: birthday, userPin: pin)
        } else {
            print("RegistrationViewModel is creating user account from email and password")
            return try await AuthService.shared.createUser(email: email, password: passwd, name: name, birthday: birthday, userPin: pin)
        }
    }
}
