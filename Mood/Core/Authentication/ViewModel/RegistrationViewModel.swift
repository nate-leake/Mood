//
//  RegistrationViewModel.swift
//  Mood
//
//  Created by Nate Leake on 9/16/23.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var passwd = ""
    @Published var birthday = Date.now
    
    func createUser() async throws {
        try await AuthService.shared.createUser(email: email, password: passwd, birthday: birthday)
    }
}
