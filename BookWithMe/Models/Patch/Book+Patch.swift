//
//  Book+Patch.swift
//  BookWithMe
//
//  Created by 계은성 on 5/28/25.
//

import Foundation
// Patch DTOs
// 선택적으로 업데이트를 하기 위해 필요함
/// 넘겨준 값만 Core Data 엔티티에 반영하는 ‘부분 업데이트’용 구조체들
struct BookPatch {
    var title: String?            = nil
    var author: String?           = nil
    var publisher: String?        = nil
    var description: String?      = nil
    var imageURL: String?         = nil
    
    func apply(to entity: BookEntity) {
        if let v = title       { entity.title           = v }
        if let v = author      { entity.author          = v }
        if let v = publisher   { entity.publisher       = v }
        if let v = description { entity.bookDescription = v }
        if let v = imageURL    { entity.imageURL        = v }
    }
}
