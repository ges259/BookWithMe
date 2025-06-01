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
    
    private let originalBook: Book    // DB에서 읽어온 직후 스냅샷
    var book: Book {
        didSet {
            dump(book)
        }
    }
    var isSavedBook: Bool

    
    
    
    
    
    // MARK: - descriptionMode
    /// BookDescriptionView + 하단 버튼
    var descriptionMode: ViewModeType
    
    
    var isEditMode: Bool {
        return self.descriptionMode == .edit
    }
    
    func turnToEditMode() {
        self.descriptionMode = .edit
        self.updateSheetState(row: .status)
    }
    
    
    
    // MARK: - bottomSheet
    /// 나의 기록 + BottomSheet
    var sheetState: BottomSheetPosition = .hidden
    private(set) var selectedRow: BookInfoRow = .none
    var allCases: [BookInfoRow] {
        return BookInfoRow.allCases
    }
    func isLast(_ item: BookInfoRow) -> Bool {
        return item == allCases.last
    }
    
    /// 화면이동 / 셀 및 특정 화면이 선택되었을 때, 호출되는 메서드.
    func updateSheetState(row: BookInfoRow) {
        self.selectedRow = row
        self.sheetState = .dynamic
    }
    
    
    
    
    
    // MARK: - init
    init(
        bookCache: BookCache,
        book: Book
    ) {
        self.bookCache = bookCache
        
        self.originalBook = book
        self.book = book
        
        self.isSavedBook = bookCache.contains(book)
        
        self.descriptionMode = book.history.status == .none
        ? .preview
        : .edit
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
            let rating = book.history.review.rating
            
            return rating.truncatingRemainder(dividingBy: 1) == 0
            // 정수로 떨어지는 경우: 1.0 → "1"
            ? String(Int(rating))
            // 소수점 포함: 0.5, 4.5 → "0.5", "4.5"
            : String(min(rating, 5))
            
        case .summary:
            return book.history.review.summary ?? ""
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







// MARK: - CoreData 저장
extension BookDataViewModel {
    
    /// 사용자가 저장 버튼을 눌렀을 때 호출되는 함수
    func saveBook() {
        Task { @MainActor in
            do {
                self.isSavedBook
                ? try await updateBookIfNeeded()
                : try await createBook()
                
                self.bookCache.update(book)
                
            } catch {
                log(error, context: "saveBook")
            }
        }
    }
    
    /// 새로운 책을 Core Data에 저장
    private func createBook() async throws {
        try await CoreDataManager.shared.save(book: book)
    }

    /// 기존 책을 변경사항이 있을 경우에만 업데이트
    private func updateBookIfNeeded() async throws {
        let (bookPatch, historyPatch, reviewPatch, hasChanged) = book.diff(from: originalBook)
        guard hasChanged else { return }

        try await CoreDataManager.shared.update(
            bookId: book.id,
            bookPatch: bookPatch,
            historyPatch: historyPatch,
            reviewPatch: reviewPatch
        )
    }

    /// 에러 로깅 유틸리티
    private func log(_ error: Error, context: String) {
        print("\(context) -- DEBUG: \(error.localizedDescription)")
    }
}


// MARK: - CoreData 삭제
extension BookDataViewModel {
    func deleteBook() {
        print(#function)
    }
}
