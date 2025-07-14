//
//  BookCache+InitLoading.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

// MARK: - 초기 로딩 / 재빌드
extension BookCache {
    
    func loadInitialData() async {
        // '사용자 정의 추천' 가져오기
        self.bookPrefs = CoreDataManager.shared.fetchBookPrefs()
        
        DispatchQueue.main.async {
            // 코어데이터에 저장된 모든 책을 가져오기
            let books = CoreDataManager.shared.fetchCoreDataBooks()
            // 책정보를 캐시에 저장
            self.load(books)
            // ai 책 추천 결과를 가져오기
            self.fetchAIRecommendations()
        }
    }
    
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
