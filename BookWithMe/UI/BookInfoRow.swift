//
//  BookInfoRow.swift
//  BookWithMe
//
//  Created by 계은성 on 5/9/25.
//

import Foundation

enum BookInfoRow: Identifiable {
    case status
    case startDate
    case endDate
    case rating
    case summary
    
    
    case description
    case none
    
    
    static var allCases: [BookInfoRow] {
        return [.status, .startDate, .endDate, .rating, .summary
        ]
    }
    
    var id: Self { self }
    
    var isFirstCell: Bool {
        return self == .status
    }
    
    
    
    var title: String {
        switch self {
        case .status: return "독서 상태"
        case .startDate: return "시작일"
        case .endDate: return "종료일"
        case .rating: return "평점"
        case .summary: return "한줄평"
        default: return ""
        }
    }
    
    var iconName: String {
        switch self {
        case .status: return "book"
        case .startDate: return "calendar"
        case .endDate: return "calendar"
        case .rating: return "star.fill"
        case .summary: return "quote.bubble"
        default: return ""
        }
    }
}
/*
 독서 상태      status
 독서 기간      startDate - endDate
 평점          rating
 한줄평         review_summary
 태그          tag
 */
