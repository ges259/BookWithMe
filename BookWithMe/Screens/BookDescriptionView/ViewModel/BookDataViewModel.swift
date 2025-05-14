//
//  BookDataViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/8/25.
//

import Foundation
import BottomSheet

enum ViewModeType {
    case preview
    case edit
}


@Observable
final class BookDataViewModel {
    var book: Book?
    var history: BookHistory? {
        didSet {
            // history가 변경될 때마다 필요한 동작을 추가할 수 있음
            print("History updated: \(String(describing: history))")
        }
    }
    
    /// BookDescriptionView + 하단 버튼
    var descriptionMode: ViewModeType = .preview
    
    var isEditMode: Bool {
        return self.descriptionMode == .edit
    }
    
    
    /// 나의 기록 + BottomSheet
    var sheetState: BottomSheetPosition = .hidden
    var selectedRow: BookInfoRow = .none
    var allCases: [BookInfoRow] {
        return BookInfoRow.allCases
    }
    
    
    
    
    init(book: Book) {
        self.book = book
        // MARK: - Fix
        // Book과 BookHistory가 같이 있는데, 나중에 리팩토링 필요
    }
    
    
    func turnToEditMode() {
        self.descriptionMode = .edit
    }
    
    
    
    
    /// 화면이동 / 셀 및 특정 화면이 선택되었을 때, 호출되는 메서드.
    func updateSheetState(row: BookInfoRow) {
        self.selectedRow = row
        self.sheetState = .dynamic
    }
    
    
    
    /// BookHistory모델에 따른 값을 리턴
    func value(for row: BookInfoRow) -> String {
        guard let history else { return "" }
        
        switch row {
        case .status:
            return history.status.rawValue
        case .startDate:
            return "\(formatted(history.startDate)) ~ \(formatted(history.endDate))"
        case .endDate:
            return "\(formatted(history.startDate)) ~ \(formatted(history.endDate))"
        case .rating:
            return history.review.map { "\($0.rating)점" } ?? "-"
        case .summary:
            return history.review?.summary ?? "-"
        case .tags:
            return history.review?.tags?.joined(separator: ", ") ?? "-"
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
