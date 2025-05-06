//
//  ReadingHistoryViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import Foundation


final class ReadingHistoryViewModel: FetchBookHistoryProtocol {
    
    var sections: [BookShelfCellViewModel] = []
    let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        
        // 데이터 가져오기
        self.fetchData()
    }
    var sectionData: [BookShelfCellViewModel] {
        return self.sections
    }
}

// MARK: - Fetch Data
extension ReadingHistoryViewModel {
    func fetchData() {
        let bookHistoryEntities = self.getBookHistoryEntities()
        
        let firstData = self.initFirstFetch(
            viewTypes: .readingHistory,
            bookHistory: bookHistoryEntities
        )
        self.sections = firstData
    }
    
    /// 코어데이터에서 30일간의 데이터를 가져온다.
    func getBookHistoryEntities(date: Date = Date()) -> [BookHistoryEntity] {
        // 코어데이터에서 날짜순으로 데이터를 가져온다.
        return self.coreDataManager.fetchRecentBookHistories(until: date)
    }
}
