//
//  Review.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct Review {
    let bookId: String
    let reviewId: String
    var updatedat: Date
    var rating: Double?
    var summary: String?
    var detail: String?
    var tags: [String]?
    var memorableQuotes: String?
    
    init?(
        entity: ReviewEntity
    ) {
        guard
            let bookId = entity.bookId,
            let reviewId = entity.reviewId,
            let updatedat = entity.updatedAt
        else {
            return nil
        }
        
        self.bookId = bookId
        self.reviewId = reviewId
        self.updatedat = updatedat
        self.rating = entity.rating
        self.summary = entity.reviewSummary
        self.detail = entity.reviewDetail
        self.memorableQuotes = entity.memorableQuotes
        
        // MARK: - Fix
//        self.tags = entity.tags
    }
}

extension Review {
    init(
        bookId: String,
        reviewId: String,
        updatedat: Date,
        rating: Double? = nil,
        summary: String? = nil,
        detail: String? = nil,
        tags: [String]? = nil,
        memorableQuotes: String? = nil
    ) {
        self.bookId = bookId
        self.reviewId = reviewId
        self.updatedat = updatedat
        self.rating = rating
        self.summary = summary
        self.detail = detail
        self.tags = tags
        self.memorableQuotes = memorableQuotes
    }
    static var DUMMY_REVIEW: Review = Review(
        bookId: "bookId",
        reviewId: "reviewId",
        updatedat: Date(),
        rating: 0,
        summary: "review_summary",
        detail: "review_detail",
        tags: ["tag1", "tag2", "tag3"],
        memorableQuotes: "memorable_quotes"
    )
}

/*(
 
 BookHistory를 날짜순으로 가져옴
 내부의 Book데이터를 통해 화면의 Book을 띄움
 해당 Book을 누르면, 화면 전환 후 Review를 볼 수 있음
 
 */
