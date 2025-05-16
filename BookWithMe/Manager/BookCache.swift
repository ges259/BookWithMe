//
//  BookCache.swift
//  BookWithMe
//
//  Created by 계은성 on 5/16/25.
//

import Foundation

// MARK: - BookCache
final class BookCache {
    static let shared = BookCache()
    private init() {}

    private var storage: [String: BookEntity] = [:]

    // MARK: 저장/조회
    func store(_ entity: BookEntity) {
        if let id = entity.bookId {
            storage[id] = entity
        }
    }
    
    /// id를 통해 BookEntity를 찾는 메서드
    func entity(by id: String) -> BookEntity? {
        storage[id]
    }
    
    // MARK: Book간 모델 변환
    /// id를 통해 LightBook을 찾는 메서드
    func lightBook(by id: String) -> LightBook? {
        entity(by: id).flatMap { LightBook(entity: $0) }
    }
    /// id를 통해 FullBook을 찾는 메서드
    func fullBook(by id: String) -> FullBook? {
        entity(by: id).flatMap { FullBook(entity: $0) }
    }
    
    
    /// [BookEntity]를 [LightBook]로 바꾸는 메서드
    func lightBooks(from entities: [BookEntity]) -> [LightBook] {
        entities.compactMap { LightBook(entity: $0) }
    }
    
    func clear() { storage.removeAll() }
}
