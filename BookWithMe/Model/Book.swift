//
//  Book+Model.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

// MARK: - LightBook
struct LightBook: Identifiable {
    let id: String
    let title: String
    let author: String
    let imageURL: String?

    init?(entity: BookEntity) {
        guard
            let id = entity.bookId,
            let title = entity.title,
            let author = entity.author
        else { return nil }

        self.id = id
        self.title = title
        self.author = author
        self.imageURL = entity.imageURL
    }
}

extension LightBook {
    // 편의 initializer (entity 없이 생성용)
    init(id: String, title: String, author: String, imageURL: String?) {
        self.id = id
        self.title = title
        self.author = author
        self.imageURL = imageURL
    }
    
    static var DUMMY: LightBook {
        LightBook(
            id: "dummy-id",
            title: "더미 책 제목",
            author: "홍길동",
            imageURL: "https://example.com/dummy.jpg"
        )
    }
}



// MARK: - FullBook
struct FullBook: Identifiable {
    let id: String
    let title: String
    let author: String
    let publisher: String
    let description: String
    let imageURL: String?
    var history: BookHistory?

    init?(entity: BookEntity) {
        guard
            let id = entity.bookId,
            let title = entity.title,
            let author = entity.author,
            let publisher = entity.publisher,
            let description = entity.bookDescription
        else { return nil }

        self.id = id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.description = description
        self.imageURL = entity.imageURL

        self.history = BookHistory.DUMMY_BOOKHISTORY
        
        if let historyEntities = entity.bookHistory {
            self.history = BookHistory(entity: historyEntities)
        }
    }
}

extension FullBook {
    // 편의 initializer (entity 없이 생성용)
    init(
        id: String,
        title: String,
        author: String,
        publisher: String,
        description: String,
        imageURL: String?,
        history: BookHistory?
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.description = description
        self.imageURL = imageURL
        self.history = history
    }
    static var DUMMY: FullBook {
        FullBook(
            id: "dummy-id",
            title: "더미 책 제목",
            author: "홍길동",
            publisher: "더미 출판사",
            description: "이 책은 테스트용 더미 설명입니다.",
            imageURL: "https://example.com/dummy.jpg",
            history: BookHistory.DUMMY_BOOKHISTORY
        )
    }
}
