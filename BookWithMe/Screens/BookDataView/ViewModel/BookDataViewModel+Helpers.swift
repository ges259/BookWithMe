//
//  BookDataViewModel+Helpers.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

// MARK: - Helper
extension BookDataViewModel {
    /// 뒤로가기 버튼을 눌렀을 때, 변경하지 않고 나간다면 원래의 데이터로 돌려놓음
    func reset() {
        if let data = self.bookCache.book(id: self.book.id) {
            self.book = data
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
    /// 현재 책이 캐시와 다른 경우 true (저장 버튼 활성화 조건)
    func isDiff() -> Bool {
        if isSavedBook {
            return self.diffFromCachedBook()?.hasChanged ?? false
        } else {
            if self.book.history.status == .none {
                self.reset()
                return false
            } else {
                return true
            }
        }
    }
}
