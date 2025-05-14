//
//  Review.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct Review {
    let id: String
    let updatedat: Date
    let rating: Int
    let summary: String?
    let detail: String?
    let tags: [String]?
    let memorableQuotes: String?
    
    let user: User                // To-One 관계 (Required)
    // bookHistory는 필요하다면 이 구조에 추가 가능
}
extension Review {
    static var DUMMY_REVIEW: Review = Review(
        id: "bookId",
        updatedat: Date(),
        rating: 0,
        summary: "review_summary",
        detail: "review_detail",
        tags: ["tag1", "tag2", "tag3"],
        memorableQuotes: "memorable_quotes", 
        user: User.DUMMY_USER
    )
}

/*(
 
 BookHistory를 날짜순으로 가져옴
 내부의 Book데이터를 통해 화면의 Book을 띄움
 해당 Book을 누르면, 화면 전환 후 Review를 볼 수 있음
 
 */
