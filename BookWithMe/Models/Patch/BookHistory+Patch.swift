//
//  BookHistory+Patch.swift
//  BookWithMe
//
//  Created by 계은성 on 5/28/25.
//

import Foundation


struct BookHistoryPatch {
    var status: ReadingStatus?   = nil
    var startDate: Date?      = nil
    var endDate: Date?        = nil
    
    func apply(to entity: BookHistoryEntity) {
        if let v = status     { entity.status    = v.rawValue }
        if let v = startDate  { entity.startDate = v }
        if let v = endDate    { entity.endDate   = v }
    }
}
