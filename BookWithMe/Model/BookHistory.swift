//
//  BookHistory.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

enum ReadingStatus {
    case recommended
    case reading
    case completed
    case paused
    case wishlist
    
    case none
    
    var title: String {
        switch self {
        case .recommended:  return "이 책은 어때요?"
        case .reading:      return "읽고 있어요"
        case .completed:    return "다 읽었어요"
        case .paused:       return "잠시 멈췄어요"
        case .wishlist:     return "읽고 싶어요"
        case .none:         return ""
        }
    }
    static var orderedSections: [ReadingStatus] = [
        .recommended,
        .reading,
        .completed,
        .wishlist,
        .paused
    ]
}

struct BookHistory {
    let book: Book
    
    let userId: String
    let bookId: String
    let status: ReadingStatus
    let startDate: Date
    let endDate: Date
}
extension BookHistory {
    static var DUMMY_BOOKHISTORY: BookHistory = BookHistory(
        book: Book.DUMMY_BOOK, 
        userId: "userId",
        bookId: "bookId",
        status: .reading,
        startDate: Date(),
        endDate: Date()
    )
}
