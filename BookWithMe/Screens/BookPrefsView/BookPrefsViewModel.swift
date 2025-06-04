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
    
    
    private(set) var selectedRow: CustomPrefsType = .ageGroup
    private let bookCache: BookCache
    var bookprefs: BookPrefs {
        didSet {
            print("BookPrefsViewModel")
            dump(bookprefs)
        }
    }
    
    var allCases: [CustomPrefsType] = {
        return CustomPrefsType.allCases
    }()
    
    
    init(bookCache: BookCache) {
        self.bookCache = bookCache
        self.bookprefs = bookCache.bookPrefs
    }
    
    func saveBookPrefs() {
        bookCache.saveBookPrefs()
    }
    
    
    /// 화면이동 / 셀 및 특정 화면이 선택되었을 때, 호출되는 메서드.
    func updateSheetState(row: CustomPrefsType) {
        self.selectedRow = row
        self.sheetState = .dynamic
    }
    
    /// CustomPrefsType모델에 따른 값을 리턴
    func value(for row: CustomPrefsType) -> String? {
        switch row {
        case .language:
            return labelsString(bookprefs.language)
        case .pageLength:
            return labelsString(bookprefs.pageLength)
        case .ageGroup:
            return labelsString(bookprefs.ageGroup)
        case .readingPurpose:
            return labelsString(bookprefs.readingPurpose)
        case .likedGenres:
            return labelsString(bookprefs.likedGenres)
        case .dislikedGenres:
            return labelsString(bookprefs.dislikedGenres)
        }
    }
    /// PrefsOption 배열을 문자열로 변환하는 유틸리티 함수
    func labelsString<T: PrefsOption>(
        _ options: [T],
        maxCount: Int = 5
    ) -> String {
        let labels = options.map(\.label)
        if labels.count > maxCount {
            let shown = labels.prefix(maxCount)
            return shown.joined(separator: ", ") + " 등"
        } else {
            return labels.joined(separator: ", ")
        }
    }
}



private extension BookPrefsViewModel {

}
