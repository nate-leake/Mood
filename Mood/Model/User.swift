//
//  User.swift
//  Mood
//
//  Created by Nate Leake on 9/20/23.
//

import Foundation

/// Contains basic information about the user
struct User: Codable {
    let email: String // email is currently let which will prohibit the user from updating this informarion.
    var name: String
    var birthday: Date
    var pin: Data
}

extension User {
    static var MOCK_USERS: [User] = [
        .init(email: "swiftui@preview.com", name: "Preview", birthday: Date.now, pin: Data())
    ]
}
