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

    init() {
        self.sections = self.makeSections()
    }

    var sectionData: [BookShelfCellViewModel] { sections }
}
