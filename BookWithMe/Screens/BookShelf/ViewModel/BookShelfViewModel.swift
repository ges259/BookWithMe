//
//  BookShelfViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

// MARK: - BookShelfViewModel
@Observable
final class BookShelfViewModel: FetchBookHistoryProtocol {
    var sections: [BookShelfCellViewModel] = []

    init() {
        self.sections = self.makeSections()
    }

    
    /// 추천 섹션(있으면)
    var recommendedSection: BookShelfCellViewModel? {
        sections.first { $0.readingStatus == .recommended }
    }

    /// 추천 외 나머지 섹션
    var otherSections: [BookShelfCellViewModel] {
        sections.filter { $0.readingStatus != .recommended }
    }

    /// 한 번만 생성하기 위해 static으로 생성
    static let gridColumns: [GridItem] =
          Array(repeating: .init(.flexible(), spacing: 0), count: 2)
    
    /// 그리드 컬럼 구성(2열)
    var gridColumns: [GridItem] { Self.gridColumns }
}
