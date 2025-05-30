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
        let books = self.coreDataManager.fetchBooksForMonth()
        
        self.sections = initFirstFetch(
            viewTypes: .bookShelf,
            books: books
        )
    }
}
