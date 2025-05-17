//
//  ReadingHistoryViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import Foundation


// MARK: - ReadingHistoryViewModel
final class ReadingHistoryViewModel: FetchBookHistoryProtocol {

    // 섹션 배열
    var sections: [BookShelfCellViewModel] = []
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.fetchData()
    }

    /// 뷰에서 바인딩할 때 쓰는 읽기 전용 프로퍼티
    var sectionData: [BookShelfCellViewModel] { sections }
}

// MARK: - Fetch Data
extension ReadingHistoryViewModel {

    func fetchData() {
        // 최근 30일 LightBook 목록
        let lightBooks = getLightBooksWithin30Days()
        // ✅ LightBook 기반 섹션 생성
        self.sections = initFirstFetch(
            viewTypes: .readingHistory,
            lightBooks: lightBooks
        )
    }

    /// Core Data → LightBook 변환 (최근 30일)
    private func getLightBooksWithin30Days(date: Date = Date()) -> [LightBook] {
        coreDataManager.fetchLightBooksForMonth(containing: date)
        // CoreDataManager 내부에서 BookCache.store(_:) 호출이 이미 이루어짐
    }
}
