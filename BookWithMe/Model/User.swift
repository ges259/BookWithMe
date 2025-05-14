//
//  User.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct User {
    let userId: String
    let name: String
    let userImage: String
}

extension User {
    static var DUMMY_USER: User = User(
        userId: "dummy_userId",
        name: "dummy_Nickname",
        userImage: "person.crop.circle"
    )
}


