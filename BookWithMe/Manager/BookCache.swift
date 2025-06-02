//
//  BookCache.swift
//  BookWithMe
//
//  Created by 계은성 on 5/16/25.
//

import SwiftUI
import Observation

// MARK: - Observable BookCache
@Observable
final class BookCache {
    static let shared = BookCache()
    
    // 관찰 필요 없는 원본 저장소
//    @ObservationIgnored
    private var storage: [String: Book] = [:]
    
    // 관측이 필요한 데이터들
    var bookPrefs: BookPrefs
    var bookData: [ReadingStatus: [String]] = [:]
    
    init() {
        self.bookPrefs = CoreDataManager.shared.fetchBookPrefs()
        dump(bookPrefs)
        DispatchQueue.main.async {
            let books = CoreDataManager.shared.fetchBooksForMonth()
            self.load(books)
        }
    }
    
    func books(for status: ReadingStatus) -> [Book] {
        guard let ids = bookData[status] else { return [] }
        return ids.compactMap { storage[$0] }
    }
}



// MARK: - CRUD (실시간 반영)
extension BookCache {
    func book(id: String) -> Book? {
        storage[id]
    }
    func contains(_ book: Book) -> Bool {
        return storage[book.id] != nil
    }
    
    func store(_ book: Book) {
        storage[book.id] = book
        bookData[book.history.status, default: []].append(book.id)
    }

    func update(_ book: Book) {
        guard let old = storage[book.id] else { return }
        storage[book.id] = book
        
        if old.history.status != book.history.status {
            remove(book.id, from: old.history.status)
            bookData[book.history.status, default: []].append(book.id)
        }
    }
    // remove 함수도 ID 기준으로 그대로 사용 가능
    private func remove(_ id: String, from status: ReadingStatus) {
        guard var arr = bookData[status] else { return }
        arr.removeAll { $0 == id }
        bookData[status] = arr
    }
    
    func clear() {
        storage.removeAll()
        bookData.removeAll()
    }
}


// MARK: - 초기 로딩 / 재빌드
private extension BookCache {
    /// 서버에서 받아온 Book 배열을 한 번에 캐시 + 딕셔너리화
    ///
    /// ```swift
    /// let books = await api.fetchBooks()      // [Book]
    /// BookCache.shared.load(books)            // UI 즉시 갱신
    /// ```
    func load(_ books: [Book]) {
        storage = Dictionary(uniqueKeysWithValues: books.map { ($0.id, $0) })
        rebuildDictionary(from: books)
    }

    /// 캐시에 남은 Book들로 bookData를 다시 구성
    /// (필요하면 언제든 호출 가능)
    func rebuildDictionary(from books: [Book]? = nil) {
        let source = books ?? Array(storage.values)
        
        let grouped = Dictionary(grouping: source, by: { $0.history.status })
        
        // ID만 저장하도록 변경
        bookData = grouped.mapValues { books in
            books.map { $0.id }
        }
    }
}
extension BookCache {
    func saveBookPrefs() {
        print("1")
        dump(bookPrefs)
        Task {
            do {
                try await CoreDataManager.shared.save(bookPrefs: bookPrefs)
                print("2")
            } catch {
                print("DEBUG: saveBookPrefsError, \(error.localizedDescription)")
            }
        }
    }
    
    func saveBookPrefs(_ bookPrefs: BookPrefs) {
        self.bookPrefs = bookPrefs
    }
}
