//
//  BookShelfViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

final class BookShelfViewModel {
    
    var sections: [BookShelfCellViewModel] = []
    
    init() {
        self.generateDummyData()
    }
    
    private func generateDummyData() {
        ReadingStatus.orderedSections.forEach { status in
            print(status)
            print(status.title)
            sections.append(BookShelfCellViewModel(
                readingStatus: status,
                bookHistoryArray: [])
            )
        }
    }
}
