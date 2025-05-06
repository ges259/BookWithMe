//
//  BookShelfCellViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

final class BookShelfCellViewModel {
    var readingStatus: ReadingStatus
    var bookArray: [Book] = []
    
    init(
        readingStatus: ReadingStatus,
        bookHistoryArray: [Book] = [
            Book.DUMMY_BOOK,
            Book.DUMMY_BOOK
        ]
    ) {
        self.readingStatus = readingStatus
        self.bookArray = bookHistoryArray
        
        
        // MARK: - Fix
        let random = Int.random(in: 0..<4)
        for _ in 0...random {
            self.bookArray.append(Book.DUMMY_BOOK)
        }
    }
    
    var title: String {
        return self.readingStatus.title
    }
    
    func imageUrl() -> String {
        
        return ""
    }
    
    
    
    
}
