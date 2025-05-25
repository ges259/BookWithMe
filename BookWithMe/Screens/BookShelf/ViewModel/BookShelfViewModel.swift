//
//  BookShelfViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

// MARK: - BookShelfViewModel
@Observable
final class BookShelfViewModel: FetchBookHistoryProtocol {

    var sections: [BookShelfCellViewModel] = []
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.fetchData()
    }

    var sectionData: [BookShelfCellViewModel] { sections }
}

// MARK: - Fetch Data
extension BookShelfViewModel {

    /// 앱 첫 진입 시 호출
    func fetchData() {
        // 이번 달 book 목록
        let books = getBooksThisMonth()
        self.sections = initFirstFetch(
            viewTypes: .bookShelf,
            books: books
        )
    }

    /// Core Data에서 이번 달 범위의 BookHistory → Book 배열 변환
    private func getBooksThisMonth() -> [Book] {
        // 책을 가져올 범위를 계산
        guard let range = Date.startAndEndOfMonth() else { return [] }
        // 코어데이터에서 책을 가져옴
        let bookHistoryEntities = coreDataManager.fetchBookHistory(
            from: range.startOfMonth,
            to: range.endOfMonth
        )

        // Bookcache에 데이터 저장 및 Book 배열 반환
        return bookHistoryEntities.compactMap { history in
            guard let bookEntity = history.book else { return nil }
            let book = Book(entity: bookEntity)
            // 캐싱
            BookCache.shared.store(book)
            return book
        }
    }
}
