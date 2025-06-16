//
//  Review.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

enum ReviewType {
    case none
    case created
    case changed
}
// MARK: - Model
struct Review: Codable { // Decodable 프로토콜 추가
    let reviewId: String
    var updatedat: Date
    var rating: Double
    var summary: String?
    var detail: String?
    var tags: [String]?
    var memorableQuotes: String?

    // MARK: - Decodable Conformance (추가 필요)
    enum CodingKeys: String, CodingKey {
        case reviewId
        case updatedat
        case rating
        case summary
        case detail
        case tags
        case memorableQuotes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reviewId = try container.decode(String.self, forKey: .reviewId)
        self.updatedat = try container.decode(Date.self, forKey: .updatedat) // Date 디코딩
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary)
        self.detail = try container.decodeIfPresent(String.self, forKey: .detail)
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags) // 옵셔널 배열 디코딩
        self.memorableQuotes = try container.decodeIfPresent(String.self, forKey: .memorableQuotes)
    }
}

// MARK: - init (기존 코드 유지)
extension Review {
    init?(entity: ReviewEntity) {
        guard
            let reviewId = entity.reviewId,
            let updatedat = entity.updatedAt
        else { return nil }

        self.reviewId = reviewId
        self.updatedat = updatedat
        self.rating = entity.rating
        self.summary = entity.reviewSummary
        self.detail = entity.reviewDetail
        self.memorableQuotes = entity.memorableQuotes

        // MARK: - Fix: CoreData entity에서 tags를 어떻게 가져오는지 확인 필요
        // 현재 entity.tags가 없거나 String 형태일 가능성이 있습니다.
        // tags가 String 형태의 콤마로 구분된 문자열이라면, split(separator: ",") 등을 사용해야 합니다.
        // 예시: self.tags = entity.tagsString?.split(separator: ",").map(String.init) ?? []
        self.tags = [] // 이 부분은 실제 데이터 소스에 맞게 수정해야 합니다.
    }

    init() {
        self.reviewId = UUID().uuidString
        self.updatedat = Date()
        self.rating = 0
        self.summary = nil
        self.detail = nil
        self.tags = nil
        self.memorableQuotes = nil
    }

    static var DUMMY_REVIEW: Review = Review()
}
