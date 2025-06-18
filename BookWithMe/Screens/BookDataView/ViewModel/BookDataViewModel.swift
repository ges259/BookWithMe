//
//  BookDataViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/8/25.
//

import Foundation
import BottomSheet
import SwiftUI

/// 책 데이터를 관리하는 ViewModel입니다.
/// CoreData 및 캐시(BookCache)와 동기화된 책 정보를 기반으로
/// UI 상태와 저장/수정 로직을 제어합니다.
@Observable
final class BookDataViewModel {
    
    // MARK: - Dependencies
    /// 저장된 책 정보를 캐싱한 객체 (CoreData와 동기화됨)
    let bookCache: BookCache
    
    /// CoreData 연동 관리자 객체
    let coreDataManager: CoreDataManager

    
    // MARK: - 데이터 모델
    /// 현재 화면에서 사용 중인 책 객체
    /// 값이 변경되면 저장 버튼 노출 여부도 함께 업데이트
    var book: Book {
        didSet {
            self.showSaveButton = self.isDiff()
        }
    }

    /// 현재 Alert 상태 (확인/취소용 타입)
    var alertType: ConfirmationType? = nil

    
    // MARK: - UI 상태값
    /// 책 설명 뷰 모드 (.preview 또는 .edit)
    var descriptionMode: ViewModeType

    /// 바텀시트 현재 위치 상태 (.hidden, .dynamic 등)
    var sheetState: BottomSheetPosition = .hidden

    /// 현재 선택된 셀 종류 (상태, 평점 등)
    var selectedRow: BookInfoRow = .none

    /// 저장 버튼을 노출할지 여부 (변경사항이 있을 경우 true)
    var showSaveButton: Bool = false


    // MARK: - 상태 판별 (Computed)
    /// 현재 책이 저장된 책인지 여부
    var isSavedBook: Bool {
        return bookCache.contains(book)
    }

    /// 현재 모드가 수정 가능한 상태인지 여부
    var isEditMode: Bool {
        return self.descriptionMode == .edit
    }

    
    // MARK: - UI 데이터 소스
    /// BookInfoRow 열거형 전체 목록 (테이블 뷰 구성에 사용)
    var allCases: [BookInfoRow] = {
        return BookInfoRow.allCases
    }()


    // MARK: - Init
    /// ViewModel 초기화 메서드
    /// - Parameters:
    ///   - bookCache: 저장된 책 캐시
    ///   - coreDataManager: CoreData 관리자
    ///   - book: 화면에서 사용할 책 객체
    init(
        bookCache: BookCache,
        coreDataManager: CoreDataManager,
        book: Book
    ) {
        self.bookCache = bookCache
        self.coreDataManager = coreDataManager
        self.book = book

        // 책의 상태가 설정되어 있지 않으면 .preview 모드, 아니면 .edit 모드로 시작
        self.descriptionMode = book.history.status == .none
            ? .preview
            : .edit
    }
}
