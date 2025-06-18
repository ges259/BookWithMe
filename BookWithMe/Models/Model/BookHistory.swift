//
//  BookHistory.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation

// MARK: - Model
struct BookHistory: Codable {
    var bookId: String
    var bookHistoryId: String
    var status: ReadingStatus
    var startDate: Date?
    var endDate: Date?
    var review: Review

    // MARK: - Decodable Conformance (추가 필요)
    enum CodingKeys: String, CodingKey {
        case bookId
        case bookHistoryId
        case status
        case startDate
        case endDate
        case review
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bookId = try container.decode(String.self, forKey: .bookId)
        self.bookHistoryId = try container.decode(String.self, forKey: .bookHistoryId)
        
        // ReadingStatus는 RawRepresentable (String) 이므로 바로 디코딩 가능
        self.status = try container.decode(ReadingStatus.self, forKey: .status)
        
        // Date 타입은 기본적으로 ISO 8601 형식 등을 기대하며, Custom Decoder 설정이 필요할 수 있습니다.
        // 현재는 옵셔널이므로 decodeIfPresent 사용.
        self.startDate = try container.decodeIfPresent(Date.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(Date.self, forKey: .endDate)
        
        // Review도 Decodable이어야 합니다.
        self.review = try container.decode(Review.self, forKey: .review)
    }
}

// MARK: - init (기존 코드 유지)
extension BookHistory {
    /// CoreData에서 받아온 BookHistoryEntity를  BookHistory모델로 변환하는 init?()
    init?(entity: BookHistoryEntity) {
        guard
            let bookId = entity.book?.bookId,
            let bookHistoryId = entity.bookHistoryId,
            let statusRaw = entity.status,
            let status = ReadingStatus(rawValue: statusRaw)
        else { return nil }

        self.bookId = bookId
        self.bookHistoryId = bookHistoryId
        self.status = status
        self.startDate = entity.startDate ?? Date()
        self.endDate = entity.endDate

        if
            let reviewEntity = entity.review,
            let review = Review(entity: reviewEntity)
        {
            self.review = review
        } else {
            self.review = Review()
        }
    }
    /// API를 통해 받아온 데이터를 BookHistory모델로 변환하는 init()
    init(bookId: String) {
        self.bookId = bookId
        self.bookHistoryId = UUID().uuidString
        self.status = .none
        self.startDate = Date()
        self.endDate = nil
        self.review = Review()
    }
    
    mutating func reset() {
        self.status = .none
        self.startDate = Date()
        self.endDate = nil
    }
    
    /// 테스트용 Dummy
    static var DUMMY_BOOKHISTORY: BookHistory {
        return BookHistory(bookId: "BookHistory_Dummy")
    }
}
