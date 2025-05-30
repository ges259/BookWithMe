//
//  Review+Patch.swift
//  BookWithMe
//
//  Created by 계은성 on 5/28/25.
//

import Foundation

struct ReviewPatch {
    var rating: Double?           = nil
    var summary: String?          = nil
    var detail: String?           = nil
    var memorableQuotes: String?  = nil
    var tags: String?             = nil
    
    func apply(to entity: ReviewEntity) {
        if let v = rating          { entity.rating          = v }
        if let v = summary         { entity.reviewSummary   = v }
        if let v = detail          { entity.reviewDetail    = v }
        if let v = memorableQuotes { entity.memorableQuotes = v }
        if let v = tags            { entity.tags            = v }
        entity.updatedAt = Date()  // 항상 갱신
    }
}
