//
//  BookDataViewModel+UI.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

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
