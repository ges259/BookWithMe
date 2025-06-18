//
//  OpenAIResponse.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }

    let choices: [Choice]
}
