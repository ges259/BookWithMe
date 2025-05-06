//
//  BookShelfViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

@Observable
final class BookShelfViewModel: FetchBookHistoryProtocol {
    var sections: [BookShelfCellViewModel] = []
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        
        self.fetchData()
    }
    
    var sectionData: [BookShelfCellViewModel] {
        return self.sections
    }
}










// MARK: - Fetch Data
extension BookShelfViewModel {
    /// 앱에 들어오면 가장 처음 실행되는 Fetch
    func fetchData() {
        // 코어데이터에서 이번 달의 데이터를 가져온다.
        let bookHistoryEntities = self.getBookHistoryEntities()
        //
        let firstData = self.initFirstFetch(
            viewTypes: .bookShelf,
            bookHistory: bookHistoryEntities
        )
        self.sections = firstData
    }
    
    /// 코어데이터에서 이번 달의 데이터를 가져온다.
    func getBookHistoryEntities() -> [BookHistoryEntity] {
        guard let thisMonth = Date.startAndEndOfMonth() else { return [] }
        // 코어데이터에서 날짜순으로 데이터를 가져온다.
        return self.coreDataManager.fetchBookHistory(
            from: thisMonth.startOfMonth,
            to: thisMonth.endOfMonth
        )
    }
}
