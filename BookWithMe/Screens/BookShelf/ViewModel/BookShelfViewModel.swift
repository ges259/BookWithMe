//
//  BookShelfViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

final class BookShelfViewModel {
    
    var sections: [BookShelfCellViewModel] = []
    private let coreDataManager: CoreDataManager = CoreDataManager.shared
    
    init() {
        self.generateDummyData()
    }
    
    private func generateDummyData() {
        ReadingStatus.orderedSections.forEach { status in
            
            sections.append(BookShelfCellViewModel(
                readingStatus: status,
                bookHistoryArray: [])
            )
        }
        
        self.fetchData()
        print("끝___________________________________")
        self.sections.forEach { viewModel in
            print(viewModel.bookArray)
        }
        print("끝___________________________________")
    }
}



















// MARK: - Fetch Data
extension BookShelfViewModel {
    
    // fetchData 함수 리팩토링: 책임을 분리하여 간결하고 명확하게
    private func fetchData() {
        guard let thisMonth = Date.startAndEndOfMonth() else { return }
        // 코어데이터에서 날짜순으로 데이터를 가져온다.
        let bookHistoryEntities = coreDataManager.fetchBookHistory(
            from: thisMonth.startOfMonth,
            to: thisMonth.endOfMonth
        )
        print("__________________fetchData_________________")
        print("bookHistoryEntities : \(bookHistoryEntities)")
        bookHistoryEntities.forEach { print("📕 Entity status: \($0.status ?? "nil")") }

        // 섹션별로 필터링된 데이터 업데이트
        ReadingStatus.orderedSections.forEach { status in
            // 가져온 BookHistory의 Entity들을 업데이트 시작
            let filteredBookHistory = filterBookHistory(bookHistoryEntities, by: status)
            
            print("filteredBookHistory : \(filteredBookHistory)")
            print("__________________fetchData_________________")
            updateSection(for: status, with: filteredBookHistory)
        }
    }
    
    // 상태에 맞는 BookHistoryEntity 필터링 메서드
    private func filterBookHistory(
        _ bookHistoryEntities: [BookHistoryEntity],
        by status: ReadingStatus
    ) -> [BookHistoryEntity] {
        // readingStaus가 맞는지 filter함수로 체크
        return bookHistoryEntities.filter {
            guard let statusString = $0.status else { return false }
            return ReadingStatus(rawValue: statusString) == status
        }
    }
    
    // 섹션 업데이트 메서드: filteredBookHistory를 섹션에 맞게 추가
    private func updateSection(
        for status: ReadingStatus,
        with filteredBookHistory: [BookHistoryEntity]
    ) {
        print("__________________updateSection_________________")
        print("첫 status : \(status)")
        print("[filteredBookHistory] : \(filteredBookHistory)")
        guard let sectionIndex = sections.firstIndex(where: { $0.readingStatus == status }) else { return }
        
        let bookArray = filteredBookHistory.compactMap { bookHistory in
            print("relationship : \(bookHistory.relationship)")
            // BookEntity를 Book으로 변환하여 반환
            return convertToBook(from: bookHistory.relationship)
        }
        
        
        sections[sectionIndex].bookArray = bookArray
        
        
        print("status : \(status)")
        print("bookArry : \(sections[sectionIndex].bookArray)")
        print("__________________updateSection_________________")
    }
    
    // BookEntity를 Book으로 변환하는 메서드
    private func convertToBook(from bookEntity: BookEntity?) -> Book? {
        guard let bookEntity = bookEntity else { return nil }
        return Book.fromEntity(bookEntity)
    }
}
