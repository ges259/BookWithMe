//
//  User.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct User {
    let userId: String
    let userImage: String
    let nickname: String
}

extension User {
    static var DUMMY_USER: User = User(
        userId: "dummy_userId",
        userImage: "person.crop.circle",
        nickname: "dummy_Nickname"
    )
}


