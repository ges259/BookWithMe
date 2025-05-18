//
//  FetchBookHistoryProtocol.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import Foundation


// MARK: - FetchBookHistoryProtocol
protocol FetchBookHistoryProtocol {
    var sections: [BookShelfCellViewModel] { get }
    func fetchData()
}

// MARK: - 첫 페치 + 추가 페치
extension FetchBookHistoryProtocol {

    /// Book만 받아 첫 섹션 데이터를 생성
    func initFirstFetch(
        viewTypes: ReadingViewTypes,
        books: [Book]
    ) -> [BookShelfCellViewModel] {

        var sectionData: [BookShelfCellViewModel] = []

        ReadingStatus
            .viewTypes(viewTypes)
            .forEach { status in

                let filteredBooks = filterBooksStatus(books, by: status)

                if let index = getSectionsIndex(sections: sectionData, status: status) {
                    sectionData[index].updateBookArray(filteredBooks)
                } else {
                    let newSection = BookShelfCellViewModel(readingStatus: status)
                    newSection.updateBookArray(filteredBooks)
                    sectionData.append(newSection)
                }
            }

        return sectionData
    }

    /// 추가 로드 / 페이지네이션용 훅
    func moreFetch(status: ReadingStatus) {
        // 이후 필요 시 구현
    }
}

// MARK: - 내부 헬퍼
extension FetchBookHistoryProtocol {

    /// 상태에 맞는 Book 필터링
    func filterBooksStatus(
        _ books: [Book],
        by status: ReadingStatus
    ) -> [Book] {
        books.filter { book in
            book.history.status == status
        }
    }

    /// 섹션 배열에서 지정한 상태의 인덱스 반환
    func getSectionsIndex(
        sections: [BookShelfCellViewModel],
        status: ReadingStatus
    ) -> Int? {
        sections.firstIndex { $0.readingStatus == status }
    }
}
