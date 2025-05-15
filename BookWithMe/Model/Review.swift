//
//  Review.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct Review {
    let id: String
    var updatedat: Date
    var rating: Double?
    var summary: String?
    var detail: String?
    var tags: [String]?
    var memorableQuotes: String?
    
//    let user: User                // To-One 관계 (Required)
    // bookHistory는 필요하다면 이 구조에 추가 가능
    
    init(
        id: String,
        updatedat: Date,
        rating: Double? = nil,
        summary: String? = nil,
        detail: String? = nil,
        tags: [String]? = nil,
        memorableQuotes: String? = nil
//         user: User
    ) {
        self.id = id
        self.updatedat = updatedat
        self.rating = rating
        self.summary = summary
        self.detail = detail
        self.tags = tags
        self.memorableQuotes = memorableQuotes
//        self.user = user
    }
    
    init?(
        bookId: String,
        entity: ReviewEntity
    ) {
        guard let updatedat = entity.updatedAt else {
            return nil
        }
        
        self.id = bookId
        self.updatedat = updatedat
        self.rating = entity.rating
        self.summary = entity.reviewSummary
        self.detail = entity.reviewDetail
        self.memorableQuotes = entity.memorableQuotes
        
        // MARK: - Fix
//        self.tags = entity.tags
//        self.user = User(userId: "", name: "", userImage: "")  // User 변환 처리 필요
    }
    
    
    
}
extension Review {
    static var DUMMY_REVIEW: Review = Review(
        id: "bookId",
        updatedat: Date(),
        rating: 0,
        summary: "review_summary",
        detail: "review_detail",
        tags: ["tag1", "tag2", "tag3"],
        memorableQuotes: "memorable_quotes"
    )
}

/*(
 
 BookHistory를 날짜순으로 가져옴
 내부의 Book데이터를 통해 화면의 Book을 띄움
 해당 Book을 누르면, 화면 전환 후 Review를 볼 수 있음
 
 */




// MARK: - BookCache
final class BookCache {
    static let shared = BookCache()
    private init() {}

    private var storage: [String: BookEntity] = [:]
    private let context = CoreDataManager.shared

    func store(_ entity: BookEntity) {
        if let id = entity.bookId {
            storage[id] = entity
        }
    }

    func get(by id: String) -> BookEntity? {
        return storage[id]
    }


    func clear() {
        storage.removeAll()
    }
}
