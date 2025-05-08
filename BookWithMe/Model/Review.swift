//
//  Review.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct Review {
    let bookId: String
    let userId: String
    
    // 리뷰
    let created_at: Date
    let rating: Int
    let review_summary: String
    let review_detail: String
    let tags: [String]
    let memorable_quotes: String
}
extension Review {
    static var DUMMY_REVIEW: Review = Review(
        bookId: "bookId",
        userId: "userId",
        created_at: Date(),
        rating: 0,
        review_summary: "review_summary",
        review_detail: "review_detail",
        tags: ["tag1", "tag2", "tag3"],
        memorable_quotes: "memorable_quotes"
    )
}

/*(
 
 BookHistory를 날짜순으로 가져옴
 내부의 Book데이터를 통해 화면의 Book을 띄움
 해당 Book을 누르면, 화면 전환 후 Review를 볼 수 있음
 
 */
