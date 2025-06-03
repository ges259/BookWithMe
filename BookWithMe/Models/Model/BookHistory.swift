//
//  BookHistory.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

// MARK: - Model
struct BookHistory {
    var bookId: String
    var bookHistoryId: String
    var status: ReadingStatus
    var startDate: Date?
    var endDate: Date?
    var review: Review
}

// MARK: - init
extension BookHistory {
    /// CoreData에서 받아온 BookHistoryEntity를  BookHistory모델로 변환하는 init?()
    init?(entity: BookHistoryEntity) {
        guard
            let bookId = entity.book?.bookId,
            let bookHistoryId = entity.bookHistoryId,
            let statusRaw = entity.status,
            let status = ReadingStatus(rawValue: statusRaw)
        else { return nil }
        
        self.bookId = bookId
        self.bookHistoryId = bookHistoryId
        self.status = status
        self.startDate = entity.startDate ?? Date()
        self.endDate = entity.endDate
        
        if
            let reviewEntity = entity.review,
            let review = Review(entity: reviewEntity)
        {
            self.review = review
        } else {
            self.review = Review()
        }
    }
    /// API를 통해 받아온 데이터를 BookHistory모델로 변환하는 init()
    init(bookId: String) {
        self.bookId = bookId
        self.bookHistoryId = UUID().uuidString
        self.status = .none
        self.startDate = Date()
        self.endDate = nil
        self.review = Review()
    }
    
    /// 테스트용 Dummy
    static var DUMMY_BOOKHISTORY: BookHistory {
        return BookHistory(bookId: "BookHistory_Dummy")
    }
}

