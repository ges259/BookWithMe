//
//  CreateCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

extension CoreDataManager {
    // MARK: - Book 저장
    // 🚩 단일 진입점: Book + BookHistory + Review 저장
    func save(book model: Book) async throws {
        try await PersistenceManager.shared.container.performBackgroundTask { context in
            // 1) Book upsert
            let book = try self.upsertBook(
                model,
                in: context
            )
            
            // 2) Review 생성
            let review = self.createReview(
                from: model.history.review,
                in: context
            )
            
            // 3) BookHistory upsert
            try self.upsertBookHistory(
                for: book,
                review: review, 
                from: model.history,
                in: context
            )
            
            // 4) Save all changes
            try self.saveContext(context)
        }
    }
}




// MARK: - upsert

private extension CoreDataManager {
    
    // MARK: - Book
    func upsertBook(
        _ model: Book,
        in context: NSManagedObjectContext
    ) throws -> BookEntity {
        return try Self.upsert(
            entity: BookEntity.self,
            idKey: "bookId",
            idValue: model.id,
            in: context
        ) { (book: BookEntity) in
            book.bookId          = model.id
            book.title           = model.title
            book.author          = model.author
            book.publisher       = model.publisher
            book.bookDescription = model.description
            book.imageURL        = model.imageURL
            book.keywords        = model.keywords.toKeywordString()
        }
    }
    
    // MARK: - Review
    func createReview(
        from reviewModel: Review,
        in context: NSManagedObjectContext
    ) -> ReviewEntity {
        let review = ReviewEntity(context: context)
        review.reviewId        = UUID().uuidString
        review.updatedAt       = Date()
        review.rating          = reviewModel.rating
        review.reviewSummary   = reviewModel.summary
        review.reviewDetail    = reviewModel.detail
        review.tags            = ""
        review.memorableQuotes = reviewModel.memorableQuotes
        return review
    }
    
    // MARK: - BookHistory
    func upsertBookHistory(
        for book: BookEntity,
        review: ReviewEntity,
        from historyModel: BookHistory,
        in context: NSManagedObjectContext
    ) throws {
        _ = try Self.upsert(
            entity: BookHistoryEntity.self,
            idKey: "bookHistoryId",
            idValue: historyModel.bookHistoryId,
            in: context
        ) { (history: BookHistoryEntity) in
            history.bookHistoryId = historyModel.bookHistoryId
            history.status        = historyModel.status.rawValue
            history.startDate     = historyModel.startDate ?? Date()
            history.endDate       = historyModel.endDate
            history.book          = book
            book.bookHistory      = history
            history.review        = review
            review.bookHistory    = history
        }
    }
}
