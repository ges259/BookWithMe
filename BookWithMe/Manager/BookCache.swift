//
//  BookCache.swift
//  BookWithMe
//
//  Created by 계은성 on 5/16/25.
//

import Foundation

// MARK: - BookCache
final class BookCache {
    static let shared = BookCache()
    private var storage: [String: Book] = [:]

    func store(_ book: Book) {
        storage[book.id] = book
    }

    func book(id: String) -> Book? {
        storage[id]
    }

    func contains(_ book: Book) -> Bool {
        return storage[book.id] != nil
    }

    func clear() {
        storage.removeAll()
    }
}
