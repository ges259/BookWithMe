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
        self.sections =  self.makeSections()
    }

    /// 뷰에서 바인딩할 때 쓰는 읽기 전용 프로퍼티
    var sectionData: [BookShelfCellViewModel] { sections }
}
