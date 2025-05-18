//
//  BookDataViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/8/25.
//

import Foundation
import BottomSheet
import SwiftUI

enum ViewModeType {
    case preview
    case edit
}


@Observable
final class BookDataViewModel {
    // MARK: - 모델
    private let bookCache: BookCache
    var book: Book
    
    
    // MARK: - descriptionMode
    /// BookDescriptionView + 하단 버튼
    var descriptionMode: ViewModeType = .preview
    
    var isEditMode: Bool {
        return self.descriptionMode == .edit
    }
    
    func turnToEditMode() {
        self.descriptionMode = .edit
    }
    
    
    
    // MARK: - bottomSheet
    /// 나의 기록 + BottomSheet
    var sheetState: BottomSheetPosition = .hidden
    var selectedRow: BookInfoRow = .none
    var allCases: [BookInfoRow] {
        return BookInfoRow.allCases
    }
    
    
    
    
    
    
    // MARK: - init
    init(
        bookCache: BookCache,
        book: Book
    ) {
        self.bookCache = bookCache
        self.book = book
    }
    
    
    
    
    
    
    /// 화면이동 / 셀 및 특정 화면이 선택되었을 때, 호출되는 메서드.
    func updateSheetState(row: BookInfoRow) {
        self.selectedRow = row
        self.sheetState = .dynamic
    }
    
    
    
    
    /// BookHistory모델에 따른 값을 리턴
    func value(for row: BookInfoRow) -> String? {
        switch row {
        case .status:
            return book.history.status.rawValue
        case .startDate:
            return formatted(book.history.startDate)
        case .endDate:
            return formatted(book.history.endDate)
        case .rating:
            let rating = book.history.review?.rating ?? 0
            return "\(rating)"
            
        case .summary:
            return book.history.review?.summary ?? ""
        case .tags:
            return book.history.review?.tags?.joined(separator: ", ") ?? ""
        default:
            return ""
        }
    }

    /// 날짜 포멧
    private func formatted(_ date: Date?) -> String {
        guard let date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
