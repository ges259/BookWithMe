//
//  BookShelfCellViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

@Observable
final class BookShelfCellViewModel {
    var readingStatus: ReadingStatus
    var bookArray: [Book] = []
    
    
    init(
        bookCache: BookCache = BookCache.shared,
        readingStatus: ReadingStatus
    ) {
        self.readingStatus = readingStatus
        
        
        self.bookArray = bookCache.books(for: readingStatus)
    }
    
    var title: String {
        return self.readingStatus.title
    }
    
    
    func updateBookArray(_ book: [Book]) {
        self.bookArray.append(contentsOf: book)
    }
}
