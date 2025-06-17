//
//  BookShelfCellViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

// MARK: - ViewModel
@Observable
final class BookShelfCellViewModel {
    var readingStatus: ReadingStatus
    var bookArray: [Book]

    var title: String { readingStatus.title }

    init(
        bookCache: BookCache = BookCache.shared,
        readingStatus: ReadingStatus
    ) {
        self.readingStatus = readingStatus
        self.bookArray = bookCache.books(for: readingStatus)
    }

    func updateBooks(with newBooks: [Book]) {
        bookArray.append(contentsOf: newBooks)
    }

    func cardSize() -> BookCardSize {
        self.readingStatus == .recommended ? .flexible : .small
    }
}
