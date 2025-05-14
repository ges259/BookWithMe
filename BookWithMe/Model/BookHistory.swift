//
//  BookHistory.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

struct BookHistory {
    let status: ReadingStatus
    let startDate: Date?
    let endDate: Date?
    let review: Review?


    init(review: Review? = nil,
         status: ReadingStatus = .none,
         startDate: Date?,
         endDate: Date?
    ) {
        self.review = review
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
    }
}
extension BookHistory {
    static var DUMMY_BOOKHISTORY: BookHistory = BookHistory(
        review: Review.DUMMY_REVIEW,
        status: .reading,
        startDate: Date(),
        endDate: Date()
    )
}
struct History {
    let book: Book
    
    let userId: String
    let bookId: String
    
    // 상태
    let status: ReadingStatus
    let startDate: Date
    let endDate: Date
    
    // 리뷰
    let rating: Int
    let review_summary: String
    let review_detail: String
    let tags: [String]
    let memorable_quotes: String
}
