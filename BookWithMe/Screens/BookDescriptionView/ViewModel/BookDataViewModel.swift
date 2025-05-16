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
//    var lightBook: LightBook
    // MARK: - 모델
    var bookCache: BookCache
    var fullBook: FullBook
    
    
//    var history: BookHistory {
//        didSet {
//            // history가 변경될 때마다 필요한 동작을 추가할 수 있음
//            dump("History updated: \(String(describing: history))")
//        }
//    }
    
    
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
        lightBook: LightBook
    ) {
        self.bookCache = bookCache

        let fullBook = bookCache.fullBook(by: lightBook.id) ?? FullBook.DUMMY
        self.fullBook = fullBook
//        self.lightBook = lightBook
//        self.history = .DUMMY_BOOKHISTORY
    }
    /// 네비게이션용 FullBook (캐시에서 변환)
    func fullBook(for lightBook: LightBook) -> FullBook? {
        return bookCache.fullBook(by: lightBook.id)
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
            return fullBook.history?.status.rawValue
        case .startDate:
            return formatted(fullBook.history?.startDate)
        case .endDate:
            return formatted(fullBook.history?.endDate)
        case .rating:
            return fullBook.history?.review.map { "\(String(describing: $0.rating))점" } ?? ""
        case .summary:
            return fullBook.history?.review?.summary ?? "-"
        case .tags:
            return fullBook.history?.review?.tags?.joined(separator: ", ") ?? "-"
        default:
            return ""
        }
    }
    
    
    
//    /// BookHistory모델에 따른 값을 리턴
//    func value(for row: BookInfoRow) -> String {
//        switch row {
//        case .status:
//            return history.status.rawValue
//        case .startDate:
//            return "\(formatted(history.startDate)) ~ \(formatted(history.endDate))"
//        case .endDate:
//            return "\(formatted(history.startDate)) ~ \(formatted(history.endDate))"
//        case .rating:
//            return history.review.map { "\(String(describing: $0.rating))점" } ?? ""
//        case .summary:
//            return history.review?.summary ?? "-"
//        case .tags:
//            return history.review?.tags?.joined(separator: ", ") ?? "-"
//        default:
//            return ""
//        }
//    }

    /// 날짜 포멧
    private func formatted(_ date: Date?) -> String {
        guard let date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
