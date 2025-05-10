//
//  BookHistory.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

struct BookHistory {
    var book: Book
    var review: Review?
    
    let status: ReadingStatus
    let startDate: Date
    let endDate: Date
}
extension BookHistory {
    static var DUMMY_BOOKHISTORY: BookHistory = BookHistory(
        book: Book.DUMMY_BOOK, 
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
