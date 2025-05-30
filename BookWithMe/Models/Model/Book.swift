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
    var keywords: [String]
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
        self.keywords = entity.keywords?.toKeywordArray() ?? []
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
        self.keywords = TagGenerator.generateTags(from: dto) // ✅ 책 정보 기반 태그 생성

        self.history = BookHistory(bookId: isbn13)
    }
}


extension Book {
    func diff(from old: Book) -> (
        book: BookPatch,
        history: BookHistoryPatch,
        review: ReviewPatch,
        changed: Bool
    ) {
        var bookPatch      = BookPatch()
        var historyPatch   = BookHistoryPatch()
        var reviewPatch    = ReviewPatch()
        var hasChange      = false
        
        // ✅ Book
        if title       != old.title       { bookPatch.title       = title;         hasChange = true }
        if author      != old.author      { bookPatch.author      = author;        hasChange = true }
        if publisher   != old.publisher   { bookPatch.publisher   = publisher;     hasChange = true }
        if description != old.description { bookPatch.description = description;   hasChange = true }
        if imageURL    != old.imageURL    { bookPatch.imageURL    = imageURL;      hasChange = true }
        
        // ✅ BookHistory
        if history.status     != old.history.status     { historyPatch.status    = history.status;    hasChange = true }
        if history.startDate  != old.history.startDate  { historyPatch.startDate = history.startDate; hasChange = true }
        if history.endDate    != old.history.endDate    { historyPatch.endDate   = history.endDate;   hasChange = true }
        
        // ✅ Review
        let newReview = history.review
        let oldReview = old.history.review
        if newReview.rating          != oldReview.rating          { reviewPatch.rating          = newReview.rating;          hasChange = true }
        if newReview.summary         != oldReview.summary         { reviewPatch.summary         = newReview.summary;         hasChange = true }
        if newReview.detail          != oldReview.detail          { reviewPatch.detail          = newReview.detail;          hasChange = true }
        if newReview.memorableQuotes != oldReview.memorableQuotes { reviewPatch.memorableQuotes = newReview.memorableQuotes; hasChange = true }
        if newReview.tags != oldReview.tags {
            reviewPatch.tags = newReview.tags?.joined(separator: ", ")
            hasChange = true
        }
        
        return (bookPatch, historyPatch, reviewPatch, hasChange)
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
