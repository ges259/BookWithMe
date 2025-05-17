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
    var bookArray: [LightBook] = []
    
    init(
        readingStatus: ReadingStatus
    ) {
        self.readingStatus = readingStatus
    }
    
    var title: String {
        return self.readingStatus.title
    }
    
    
    func updateBookArray(_ book: [LightBook]) {
        self.bookArray.append(contentsOf: book)
    }
}
