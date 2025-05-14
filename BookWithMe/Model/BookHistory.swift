//
//  BookHistory.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

struct BookHistory {
    var status: ReadingStatus
    var startDate: Date?
    var endDate: Date?
    var review: Review?


    init(status: ReadingStatus = .none,
         startDate: Date? = nil,
         endDate: Date? = nil,
         review: Review? = nil
    ) {
        self.review = review
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
    }
}
extension BookHistory {
    static var DUMMY_BOOKHISTORY: BookHistory = BookHistory(
        status: .reading,
        startDate: Date(),
        endDate: Date(),
        review: Review.DUMMY_REVIEW
    )
    
}
