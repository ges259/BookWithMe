//
//  BookHistory.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation



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
