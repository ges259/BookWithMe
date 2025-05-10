//
//  FetchBookHistoryProtocol.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import Foundation

protocol FetchBookHistoryProtocol {
    var sections: [BookShelfCellViewModel] { get }
    func fetchData()
}

extension FetchBookHistoryProtocol {
    
    func initFirstFetch(
        viewTypes: ReadingViewTypes,
        bookHistory bookHistoryEntities: [BookHistoryEntity]
    ) -> [BookShelfCellViewModel] {
        var sectionData = [BookShelfCellViewModel]()
        
        
        // 섹션별로 필터링된 데이터 업데이트
        ReadingStatus.viewTypes(viewTypes).forEach { status in
            // forEach를 통해 readingStatus와 bookHistoryEntities(가져온 데이터)의 Status 필터링
            let filteredBookHistory = self.filterBookHistory(
                bookHistoryEntities,
                by: status
            )
            
            // 현재 status에 맞는 Book을 배열로 가져옴
            let bookData = self.makeBookArray(for: status, with: filteredBookHistory)
            // status에 맞는 뷰모델에 Book 배열을 업데이트
            
            if let index = self.getSectionsIndex(
                sections: sectionData,
                status: status
            ) {
                sectionData[index].updateBookArray(bookData)
            } else {
                let newSection = BookShelfCellViewModel(readingStatus: status)
                newSection.updateBookArray(bookData)
                sectionData.append(newSection)
            }
        }
        return sectionData
    }
    
    func moreFetch(
        status: ReadingStatus
    ) {
        
    }
}



extension FetchBookHistoryProtocol {
    
    /// 상태에 맞는 BookHistoryEntity 필터링 메서드
    func filterBookHistory(
        _ bookHistoryEntities: [BookHistoryEntity],
        by status: ReadingStatus
    ) -> [BookHistoryEntity] {
        // readingStaus가 맞는지 filter함수로 체크
        return bookHistoryEntities.filter {
            guard let statusString = $0.status else { return false }
            return ReadingStatus(rawValue: statusString) == status
        }
    }
    /// BookEntity를 Book으로 변환하는 메서드
    private func convertToBook(from bookEntity: BookEntity?) -> Book? {
        guard let bookEntity = bookEntity else { return nil }
        return Book.fromEntity(bookEntity)
    }
    
    func getSectionsIndex(
        sections: [BookShelfCellViewModel],
        status: ReadingStatus
    ) -> Int? {
        return sections.firstIndex(
            where: { $0.readingStatus == status }
        )
    }
    
    /// 섹션 업데이트 메서드: filteredBookHistory를 섹션에 맞게 추가
    func makeBookArray(
        for status: ReadingStatus,
        with filteredBookHistory: [BookHistoryEntity]
    ) -> [Book] {
        let bookArray = filteredBookHistory.compactMap { bookHistory in
            // BookEntity를 Book으로 변환하여 반환
            return convertToBook(from: bookHistory.book)
        }
        return bookArray
    }
}
