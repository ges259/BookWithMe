//
//  Review.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

enum ReviewType {
    case none
    case created
    case changed
}
// MARK: - Model
struct Review {
    let reviewId: String
    var updatedat: Date
    var rating: Double
    var summary: String?
    var detail: String?
    var tags: [String]?
    var memorableQuotes: String?
}

// MARK: - init
extension Review {
    init?(entity: ReviewEntity) {
        guard
            let reviewId = entity.reviewId,
            let updatedat = entity.updatedAt
        else { return nil }
        
        self.reviewId = reviewId
        self.updatedat = updatedat
        self.rating = entity.rating
        self.summary = entity.reviewSummary
        self.detail = entity.reviewDetail
        self.memorableQuotes = entity.memorableQuotes
        
        // MARK: - Fix
        self.tags = []
    }
    
    
    init() {
        self.reviewId = UUID().uuidString
        self.updatedat = Date()
        self.rating = 0
        self.summary = nil
        self.detail = nil
        self.tags = nil
        self.memorableQuotes = nil
    }
    
    static var DUMMY_REVIEW: Review = Review()
}
