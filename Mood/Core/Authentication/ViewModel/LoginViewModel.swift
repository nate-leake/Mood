//
//  LoginViewModel.swift
//  Mood
//
//  Created by Nate Leake on 9/16/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var passwd = ""
    
    func signin() async throws {
        try await AuthService.shared.login(withEmail: email, password: passwd)
    }
}
