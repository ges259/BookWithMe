//
//  BookCache+CRUD.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

// MARK: - CRUD (실시간 반영)

extension BookCache {
    
    // MARK: - Create
    func store(_ book: Book) {
        storage[book.id] = book
        bookData[book.history.status, default: []].append(book.id)
    }
    
    
    
    // MARK: - Read
    func book(id: String) -> Book? {
        storage[id]
    }
    func contains(_ book: Book) -> Bool {
        return storage[book.id] != nil
    }
    func books(for status: ReadingStatus) -> [Book] {
        guard let ids = bookData[status] else { return [] }
        return ids.compactMap { storage[$0] }
    }
    var getAllBooks: [Book] {
        return Array(storage.values)
    }
    
    
    
    // MARK: - Update
    func update(_ book: Book) {
        guard let old = storage[book.id] else { return }
        storage[book.id] = book
        
        if old.history.status != book.history.status {
            move(book.id, from: old.history.status, to: book.history.status)
        }
    }
    
    
    
    // MARK: - Delete
    /// 주어진 책 ID를 기준으로, 캐시와 상태 딕셔너리에서 모두 제거해요
    func delete(_ bookId: String) {
        // 캐시에 해당 책이 있는지 확인
        guard let book = storage[bookId] else { return }
        // 현재 상태에서 bookId 제거
        removeIDFromBookData(bookId, from: book.history.status)
        // storage에서 완전히 제거
        storage.removeValue(forKey: bookId)
    }
    /// 모든 데이터를 삭제하는 코드
    func clear() {
        storage.removeAll()
        bookData.removeAll()
    }
    
    
    
    // MARK: - Helper
    /// 책의 ID를 이전 상태에서 새 상태로 옮기는 함수
    private func move(
        _ id: String,
        from oldStatus: ReadingStatus,
        to newStatus: ReadingStatus
    ) {
        removeIDFromBookData(id, from: oldStatus)
        bookData[newStatus, default: []].append(id)
    }
    /// remove 함수도 ID 기준으로 그대로 사용 가능
    private func removeIDFromBookData(
        _ id: String,
        from status: ReadingStatus
    ) {
        guard var arr = bookData[status] else { return }
        arr.removeAll { $0 == id }
        bookData[status] = arr
    }
}
