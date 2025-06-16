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
    @ObservationIgnored
    private var storage: [String: Book] = [:]
    
    // 관측이 필요한 데이터들
    var bookPrefs: BookPrefs
    var bookData: [ReadingStatus: [String]] = [:]
    
    var getAllBooks: [Book] {
        return Array(storage.values)
    }
    
    private init() {
        self.bookPrefs = CoreDataManager.shared.fetchBookPrefs()
        
        DispatchQueue.main.async {
            let books = CoreDataManager.shared.fetchBooksForMonth()
            self.load(books)
        }
        self.fetchAIRecommendations()
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
            move(book.id, from: old.history.status, to: book.history.status)
        }
    }
    /// 주어진 책 ID를 기준으로, 캐시와 상태 딕셔너리에서 모두 제거해요
    func delete(_ bookId: String) {
        // 캐시에 해당 책이 있는지 확인
        guard let book = storage[bookId] else { return }
        // 현재 상태에서 bookId 제거
        removeIDFromBookData(bookId, from: book.history.status)
        // storage에서 완전히 제거
        storage.removeValue(forKey: bookId)
    }
    
    
    // MARK: - CRUD_Helper
    /// 책의 ID를 이전 상태에서 새 상태로 옮기는 함수
    private func move(
        _ id: String,
        from oldStatus: ReadingStatus,
        to newStatus: ReadingStatus
    ) {
        removeIDFromBookData(id, from: oldStatus)
        bookData[newStatus, default: []].append(id)
    }
    
    // remove 함수도 ID 기준으로 그대로 사용 가능
    private func removeIDFromBookData(
        _ id: String,
        from status: ReadingStatus
    ) {
        guard var arr = bookData[status] else { return }
        arr.removeAll { $0 == id }
        bookData[status] = arr
    }
    
    /// 모든 데이터를 삭제하는 코드
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

// MARK: - AIRecommendations
extension BookCache {
//    func checkRecommendation() {
        // 가져온 Book데이터 중에서 .recommended를 필터링 해서 가져옴
        
        // 가져온 데이터중 .recommended가 없다면, 데이터를 가져옴
        
        // .recommended가 있다면 날짜를 체크
        
        // 날짜가 오늘이라면, 아무행동도 하지 않음
        
        // 날짜가 오늘이 아니라면,
            // store에서 .recommended없애기
            // 새로운 데이터 가져오기
//    }
    
    func fetchAIRecommendations() {
        print("DEBUG: ____________ prefs ____________")
        print(self.bookPrefs.toStringArrays())
        print("DEBUG: ____________________________________")
        
        AIRecommendations
            .shared
            .fetchRecommendedBooks(userPrefs: self.bookPrefs) { books in
                // 책에 있는 history.status를 .recommended로 바꿈
                let wishlistBooks = self.booksChangeToRecommend(books)
                // 책을 캐시에 저장
                wishlistBooks.forEach {self.store($0) }
            }
    }
    
    func booksChangeToRecommend(_ books: [Book]) -> [Book] {
        // status를 .wishlist로 바꿈
        let wishlistBooks = books.map { book -> Book in
            var b = book
            b.history.status = .recommended
            return b
        }
        return wishlistBooks
    }
}


// MARK: - BookPrefs
extension BookCache {
    func saveBookPrefs() {
        Task {
            do {
                try await CoreDataManager.shared.save(bookPrefs: bookPrefs)
            } catch {
                print("DEBUG: saveBookPrefsError, \(error.localizedDescription)")
            }
        }
    }
    
    func saveBookPrefs(_ bookPrefs: BookPrefs) {
        self.bookPrefs = bookPrefs
    }
}
