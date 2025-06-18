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
}

// MARK: - 첫 페치 + 추가 페치
extension FetchBookHistoryProtocol {
    /// bookData를 읽어 `[BookShelfCellViewModel]` 배열 생성
    ///
    /// - Parameter order: 섹션 정렬 기준.
    ///   전달하지 않으면 `ReadingStatus.allCases` 순서를 따릅니다.
    /// - Returns: status별 BookShelfCellViewModel 배열
    /// BookCache의 bookData를 바탕으로 섹션 배열을 구성
    func makeSections() -> [BookShelfCellViewModel] {
        // 모든 ReadingStatus에 대해 섹션 생성 (책이 없어도)
        return ReadingStatus.historyStatus(type: .bookShelf).map {
            return BookShelfCellViewModel(readingStatus: $0)
        }
    }
}
