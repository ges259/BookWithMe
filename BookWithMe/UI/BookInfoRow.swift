//
//  BookInfoRow.swift
//  BookWithMe
//
//  Created by 계은성 on 5/9/25.
//

import Foundation

enum BookInfoRow: CaseIterable, Identifiable {
    case status
    case period
    case rating
    case summary
    case tags
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .status: return "독서 상태"
        case .period: return "독서 기간"
        case .rating: return "평점"
        case .summary: return "한줄평"
        case .tags: return "태그"
        }
    }
    
    var iconName: String {
        switch self {
        case .status: return "book"
        case .period: return "calendar"
        case .rating: return "star.fill"
        case .summary: return "quote.bubble"
        case .tags: return "tag"
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
