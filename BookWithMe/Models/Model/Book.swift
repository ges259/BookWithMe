//
//  Book+Model.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

// MARK: - Model
struct Book: Identifiable, Codable {
    let id: String // 책의 고유한 id = isbn13
    let title: String // 책 제목
    let author: String // 저자
    let publisher: String? // 출판사
    let description: String // 책 설명
    let imageURL: String? // 책 이미지 URL (옵셔널)
    var category: [String] // 책 키워드
    var history: BookHistory // 책의 읽기 역사 정보
}



extension Book {
    // MARK: - Decodable Conformance (새로 추가)
    // JSON 키와 구조체 속성 이름이 다른 경우를 위해 CodingKeys를 정의
    enum CodingKeys: String, CodingKey {
        case id, title, author, publisher, description, imageURL, category, history
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decode(String.self, forKey: .author)
        self.publisher = try container.decodeIfPresent(String.self, forKey: .publisher) ?? "출판사 미상" // 기본값 제공
        self.description = try container.decode(String.self, forKey: .description)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.category = try container.decode([String].self, forKey: .category)
        self.history = BookHistory.DUMMY_BOOKHISTORY
    }
}



extension Book {
    init(entity: BookEntity) {
        self.id = entity.bookId ?? UUID().uuidString
        self.title = entity.title ?? "제목 없음"
        self.author = entity.author ?? "작가 미상"
        self.publisher = entity.publisher ?? "출판사 미상"
        self.description = entity.bookDescription ?? "설명 없음"
        self.imageURL = entity.imageURL
        self.category = entity.category.toCategoryArray()
        self.history = entity.bookHistory.flatMap { BookHistory(entity: $0) } ?? BookHistory.DUMMY_BOOKHISTORY
    }

    init?(dto: AladinBookDTO) {
        // isbn13 없으면 Book 생성 안 함
        guard let isbn13 = dto.isbn13 else { return nil }
        self.id = isbn13
        self.title = dto.title
        self.author = dto.author
        self.publisher = dto.publisher
        self.description = dto.description ?? "설명 없음"
        self.imageURL = dto.cover
        self.category = dto.categoryName.toCategoryArray()
        self.history = BookHistory(bookId: isbn13)
    }
}






struct RecommendedBook {
    let id: Int // isbn13
    let date: Date
    let title: String
}
