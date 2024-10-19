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
    @Published var name = ""
    @Published var birthday = Date.now
    @Published var pin: String = ""
    
    func createUser() async throws -> String {
        return try await AuthService.shared.createUser(email: email, password: passwd, name: name, birthday: birthday, userPin: pin)
    }
}
