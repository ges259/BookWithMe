//
//  BookPrefsViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/31/25.
//

import Foundation
import BottomSheet

// MARK: - BookPrefsViewModel
@Observable
final class BookPrefsViewModel {
    
    var sheetState: BottomSheetPosition = .hidden
    var bookArray: [Book] = []
    
    private let bookCache: BookCache
    var bookprefs: BookPrefs
    private(set) var selectedRow: CustomPrefsType = .ageGroup
    
    
    var allCases: [CustomPrefsType] = {
        return CustomPrefsType.allCases
    }()
    
    
    init(
        bookCache: BookCache
    ) {
        self.bookCache = bookCache
        self.bookprefs = BookPrefs.EMPTYDUMMY
        self.fetchBookPrefs()
        
        self.bookArray = [Book.DUMMY, Book.DUMMY, Book.DUMMY, Book.DUMMY]
    }
    
    /// 화면이동 / 셀 및 특정 화면이 선택되었을 때, 호출되는 메서드.
    func updateSheetState(row: CustomPrefsType) {
        self.selectedRow = row
        self.sheetState = .dynamic
    }
    
    /// BookHistory모델에 따른 값을 리턴
    func value(for row: CustomPrefsType) -> String? {
        switch row {
        case .language:
            return self.bookprefs.language.label
        case .pageLength:
            return self.bookprefs.pageLength.label
        case .ageGroup:
            return self.bookprefs.ageGroup.label
        case .readingPurpose:
            return self.bookprefs.readingPurpose.label
        case .likedGenres:
            return ""
        case .dislikedGenres:
            return ""
        }
    }
}



private extension BookPrefsViewModel {
    func fetchBookPrefs() {
        
    }
}
