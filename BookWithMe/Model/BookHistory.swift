//
//  BookHistory.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

struct BookHistory {
    var bookId: String
    var status: ReadingStatus
    var startDate: Date?
    var endDate: Date?
    var review: Review?
    

    init(
        bookId: String,
        status: ReadingStatus = .none,
        startDate: Date? = nil,
        endDate: Date? = nil,
        review: Review? = nil
    ) {
        self.bookId = bookId
        self.review = review
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
    }
    init?(
        bookId: String,
        entity: BookHistoryEntity
    ) {
        guard let statusRaw = entity.status,
              let status = ReadingStatus(rawValue: statusRaw) 
        else { return nil }
        
        self.bookId = bookId
        self.status = status
        self.startDate = entity.startDate
        self.endDate = entity.endDate
        self.review = nil // Review 변환이 필요하면 여기 확장 가능
    }
}
extension BookHistory {
    static var DUMMY_BOOKHISTORY: BookHistory = BookHistory(
        bookId: "bookId_Dummy",
        status: .reading,
        startDate: Date(),
        endDate: Date(),
        review: Review.DUMMY_REVIEW
    )
    
}
