//
//  User.swift
//  Mood
//
//  Created by Nate Leake on 9/20/23.
//

import Foundation

struct User: Codable {
    let email: String // email is currently let which will prohibit the user from updating this informarion.
    var birthday: Date
    
}

extension User {
    static var MOCK_USERS: [User] = [
        .init(email: "playerguy@gmail.com", birthday: Date.now)
    ]
}
