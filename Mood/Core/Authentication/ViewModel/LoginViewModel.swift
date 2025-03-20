//
//  LoginViewModel.swift
//  Mood
//
//  Created by Nate Leake on 9/16/23.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var passwd = ""
    
    func signin() async throws -> String {
        return try await AuthService.shared.login(withEmail: email, password: passwd)
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest, nonce: String) {
        request.requestedScopes = [.email]
        request.nonce = SecurityService.sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>, nonce currentNonce: String?) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                Task {
                    await AuthService.shared.login(with: credential)
                }
                
                print("\(String(describing: Auth.auth().currentUser?.uid))")
            default:
                break
                
            }
        default:
            break
        }
    }
}
