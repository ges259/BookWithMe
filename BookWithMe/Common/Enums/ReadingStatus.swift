//
//  ReadingStatus.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import Foundation

enum ReadingStatus: String, Codable {
    case recommended, reading, completed, paused, wishlist
    case all, none
    
    static func historyStatus(type: ReadingStatusType) -> [ReadingStatus] {
        switch type {
        case .bookShelf:
            return [.recommended, .reading, .completed, .wishlist, .paused]
        case .bookData:
            return [.reading, .completed, .wishlist, .paused]
        }
    }
    
    var title: String {
        switch self {
        case .recommended:  return "이 책은 어때요?"
        case .reading:      return "읽고 있어요"
        case .completed:    return "다 읽었어요"
        case .paused:       return "잠시 멈췄어요"
        case .wishlist:     return "읽고 싶어요"
        case .all:          return "전체"
        case .none:         return "독서 상태를 설정해 주세요."
        }
    }
}

enum ReadingStatusType {
   case bookShelf
   case bookData
}
