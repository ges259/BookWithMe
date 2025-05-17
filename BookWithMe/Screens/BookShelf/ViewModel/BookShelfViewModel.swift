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
        // 이번 달 LightBook 목록
        let lightBooks = getLightBooksThisMonth()
        self.sections = initFirstFetch(
            viewTypes: .bookShelf,
            lightBooks: lightBooks
        )
    }

    /// Core Data에서 이번 달 범위의 BookHistory → LightBook 변환
    private func getLightBooksThisMonth() -> [LightBook] {
        guard let range = Date.startAndEndOfMonth() else { return [] }

        // ① BookHistoryEntity fetch
        let histories = coreDataManager.fetchBookHistory(
            from: range.startOfMonth,
            to: range.endOfMonth
        )

        // ② BookEntity → BookCache 저장 & LightBook 변환
        return histories.compactMap { history in
            guard let bookEntity = history.book else { return nil }
            BookCache.shared.store(bookEntity)               // 캐싱
            return LightBook(entity: bookEntity)              // 변환
        }
    }
}
