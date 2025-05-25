//
//  Book+Model.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

// MARK: - Model
struct Book: Identifiable {
    let id: String // 책의 고유한id = isbn13
    let title: String // 책 제목
    let author: String // 저자
    let publisher: String //
    let description: String
    let imageURL: String?
    var history: BookHistory
}

// MARK: - init
extension Book {
    
    init(entity: BookEntity) {
        self.id = entity.bookId ?? UUID().uuidString
        self.title = entity.title ?? "제목 없음"
        self.author = entity.author ?? "작가 미상"
        self.publisher = entity.publisher ?? "출판사 미상"
        self.description = entity.bookDescription ?? ""
        self.imageURL = entity.imageURL
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
        self.history = BookHistory(bookId: isbn13)
    }
}

/*
 // MARK: - DUMMY init
 init(
     id: String,
     title: String,
     author: String,
     publisher: String,
     description: String,
     imageURL: String?,
     history: BookHistory
 ) {
     self.id = id
     self.title = title
     self.author = author
     self.publisher = publisher
     self.description = description
     self.imageURL = imageURL
     self.history = history
 }
 static var DUMMY: Book {
     return Book(
         id: "dummy-id",
         title: "더미 책 제목",
         author: "홍길동",
         publisher: "더미 출판사",
         description: "이 책은 테스트용 더미 설명입니다.",
         imageURL: "https://example.com/dummy.jpg",
         history: BookHistory.DUMMY_BOOKHISTORY
     )
 }
 */
