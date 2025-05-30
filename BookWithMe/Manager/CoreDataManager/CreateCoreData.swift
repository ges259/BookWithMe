//
//  CreateCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    // 여기에서 context를 가져와서 재사용
    let context: NSManagedObjectContext = PersistenceManager.shared.context
    private init() { }
    
    
    // MARK: - 저장
    func saveContext(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            /// 원본 오류를 감싼 뒤 상위 호출부로 throw
            throw CoreDataError.saveFailed(underlying: error)
        }
    }
    
    
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



private extension CoreDataManager {
    // MARK: - Book upsert
    func upsertBook(_ model: Book, in context: NSManagedObjectContext) throws -> BookEntity {
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
        }
    }
    
    // MARK: - Review 생성
    func createReview(from reviewModel: Review, in context: NSManagedObjectContext) -> ReviewEntity {
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
    
    // MARK: - BookHistory upsert
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
            history.startDate     = historyModel.startDate
            history.endDate       = historyModel.endDate
            history.book          = book             // 양방향
            book.bookHistory      = history
            history.review        = review
            review.bookHistory    = history          // 양방향
        }
    }
}



// MARK: - Upsert Helper (Generic)
private extension CoreDataManager {
    @discardableResult
    static func upsert<T: NSManagedObject>(
        entity: T.Type,
        idKey: String,
        idValue: String,
        in context: NSManagedObjectContext,
        configure: (T) -> Void
    ) throws -> T {
        do {
            let request = NSFetchRequest<T>(entityName: String(describing: entity))
            request.predicate  = NSPredicate(format: "%K == %@", idKey, idValue)
            request.fetchLimit = 1
            
            let object = try context.fetch(request).first ?? T(context: context)
            configure(object)
            return object
        } catch {
            /// fetch 실패 → CoreDataError 로 포장
            throw CoreDataError.fetchFailed(underlying: error)
        }
    }
}
