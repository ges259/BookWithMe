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
    
    //
//    let status: ReadingStatus
//    let startDate: Date
//    let endDate: Date
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
