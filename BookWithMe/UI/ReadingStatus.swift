//
//  ReadingStatus.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import Foundation

enum ReadingStatus: String {
    case recommended = "recommended"
    case reading = "reading"
    case completed = "completed"
    case paused = "paused"
    case wishlist = "wishlist"
    
    case all = "all"
    case none = "none"
    
    static var historyStatus: [ReadingStatus] {
        return [.reading, .completed, .wishlist, .paused]
    }
    
    var title: String {
        switch self {
        case .recommended:  return "이 책은 어때요?"
        case .reading:      return "읽고 있어요"
        case .completed:    return "다 읽었어요"
        case .paused:       return "잠시 멈췄어요"
        case .wishlist:     return "읽고 싶어요"
        case .all:         return "전체"
        case .none:         return ""
        }
    }
    
    static func viewTypes(_ type: ReadingViewTypes) -> [ReadingStatus]{
        switch type {
        case .bookShelf: 
            return [.recommended, .reading, .completed, .wishlist, .paused]
        case .readingHistory:
            return [ .recommended, .reading, .completed, .wishlist, .paused]
        }
    }
}


enum ReadingViewTypes {
    case bookShelf
    case readingHistory
}
