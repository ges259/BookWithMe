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
    /// 저장된 책들 캐시. CoreData와 동기화된 상태를 캐싱함
    private let bookCache: BookCache
    private let coreDataManager: CoreDataManager
    // 지금 화면에서 사용 중인 책 객체
    var book: Book
    {
        didSet {
            print("DEBUG: BookDataViewModel")
            dump(book)
        }
    }
    var alertType: ConfirmationType? = nil
    
    /// 현재 책이 저장된 책인지 여부
    private var isSavedBook: Bool {
        return bookCache.contains(book)
    }

    
    // MARK: - UI 상태값
    /// 책 설명 영역 모드: .preview / .edit
    var descriptionMode: ViewModeType
    /// 바텀시트 상태 (숨김, 동적 등)
    var sheetState: BottomSheetPosition = .hidden
    /// 어떤 row가 선택되어 있는지 기억
    private(set) var selectedRow: BookInfoRow = .none
    
    /// 책 설명 모드가 수정 모드인지 여부
    var isEditMode: Bool {
        return self.descriptionMode == .edit
    }
    
    /// BookInfoRow 전체 목록, 해당 목록으로 테이블의 행이 구성 됨
    var allCases: [BookInfoRow] = {
        return BookInfoRow.allCases
    }()

    
    // MARK: - 초기화
    init(
        bookCache: BookCache,
        coreDataManager: CoreDataManager,
        book: Book
    ) {
        self.bookCache = bookCache
        self.coreDataManager = coreDataManager
        self.book = book
        
        // 상태가 none이면 preview 모드, 아니면 edit 모드로 시작
        self.descriptionMode = book.history.status == .none
        ? .preview
        : .edit
    }
}



// MARK: - UI 관련
extension BookDataViewModel {
    /// 수정 모드로 전환하고, 바텀시트를 상태 셀로 변경
    func turnToEditMode() {
        self.descriptionMode = .edit
        self.updateSheetState(row: .status)
    }
    
    /// 바텀시트 상태를 업데이트하고 어떤 셀이 선택되었는지 저장
    func updateSheetState(row: BookInfoRow) {
        self.selectedRow = row
        self.sheetState = .dynamic
    }
    
    /// 각 셀에 맞는 데이터를 String으로 반환함 (화면 표시용)
    func value(for row: BookInfoRow) -> String? {
        switch row {
        case .status:
            return book.history.status.title
            
        case .startDate:
            return Date.formatDate(book.history.startDate)
            
        case .endDate:
            return book.history.endDate == nil
            ? "종료일을 설정해 주세요."
            : Date.formatDate(book.history.endDate)
            
        case .rating:
            let rating = book.history.review.rating
            
            // 정수면 "1", 소수점 있으면 그대로 ("4.5" 등)
            return rating.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(rating))
            : String(min(rating, 5))
            
        case .summary:
            return book.history.review.summary ?? "한줄평을 적어주세요."
            
        default:
            return ""
        }
    }
}



// MARK: - Helper
extension BookDataViewModel {
    /// 뒤로가기 버튼을 눌렀을 때, 변경하지 않고 나간다면 원래의 데이터로 돌려놓음
    func reset() {
        if let data = self.bookCache.book(id: self.book.id) {
            self.book = data
        } else {
            self.book.history = .DUMMY_BOOKHISTORY
            self.book.history.review = .DUMMY_REVIEW
            self.descriptionMode = .preview
        }
    }
    
    // 불편한 편의점
    /*
     isSavedBook가 true면 저장되어있는 책
     -> diffFromCachedBook에서 확인
     
     isSavedBook가 false면 저장이 안 되어있는 책
     -> status를 보면 된다.
     -> .none이면 아무것도 건들지 않음 == 저장할 필요 없음(리셋필요)
     -> .none이 아니라면, 저장 필요
    */
    func isDiff() -> Bool {
        if isSavedBook {
            let hasChanged = self.diffFromCachedBook()?.hasChanged ?? false
            return hasChanged
            
        } else { // 저장되어있지 않은 책
            // 변경사항이 없음 (status조차 설정하지 않음)
            if self.book.history.status == .none {
                self.reset()
               return false
                
                // 변경 사항이 존재 -> 얼럿창 띄우기
            } else {
                return true
            }
        }
    }
}



extension BookDataViewModel {
    // MARK: - CoreData 저장
    /// 저장 버튼 눌렀을 때 실행됨. 저장 여부에 따라 분기 처리.
    func saveBook() {
        Task { @MainActor in
            do {
                // 이미 저장된 책이면 업데이트, 아니면 새로 저장
                self.isSavedBook
                ? try await updateBookIfNeeded()
                : try await createBook()
                
                // 캐시도 최신 상태로 업데이트
                self.isSavedBook
                ? self.bookCache.update(book)
                : self.bookCache.store(book)
                
            } catch {
                log(error, context: "saveBook")
            }
        }
    }
    
    /// 새로운 책을 Core Data에 저장함
    private func createBook() async throws {
        try await self.coreDataManager.save(book: book)
    }
    
    

    /// 변경사항이 있는 경우 Core Data에 업데이트함
    private func updateBookIfNeeded() async throws {
        guard let diffResult = self.diffFromCachedBook() else { return }
        
        try await self.coreDataManager.update(
            bookId: book.id,
            bookPatch: diffResult.bookPatch,
            historyPatch: diffResult.historyPatch,
            reviewPatch: diffResult.reviewPatch
        )
    }

    /// 캐시된 책과 현재 책을 비교해서 변경사항이 있으면 diff 결과를 반환
    func diffFromCachedBook() -> (
        bookPatch: BookPatch,
        historyPatch: BookHistoryPatch,
        reviewPatch: ReviewPatch,
        hasChanged: Bool
    )? {
        // 캐시에서 원래 책을 가져옴
        guard let originalBook = self.bookCache.book(id: self.book.id) else { return nil }
        
        // 변경된 부분 파악 (diff)
        return book.diff(from: originalBook)
    }
    
    /// 에러가 발생했을 때 로그 출력용
    private func log(_ error: Error, context: String) {
        print("\(context) -- DEBUG: \(error.localizedDescription)")
    }

    
    
    // MARK: - CoreData 삭제
    /// 책 삭제 (아직 구현 안 함)
    func deleteBook() {
        Task { @MainActor in
            do {
                try await self.coreDataManager.delete(bookId: self.book.id)
                
                // 캐시도 최신 상태로 업데이트
                self.bookCache.delete(book.id)
            } catch {
                log(error, context: #function)
            }
        }
    }
}
