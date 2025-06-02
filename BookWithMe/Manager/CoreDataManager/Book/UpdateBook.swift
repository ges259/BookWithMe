//
//  UpdateCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData


/// 간단한 도메인 오류
enum CoreDataError: LocalizedError {
    
    // Create
    /// fetch-계열 실패
    case fetchFailed(underlying: Error)
    /// save-계열 실패
    case saveFailed(underlying: Error)
    // Update
    case bookNotFound, historyNotFound
    
    var errorDescription: String? {
        switch self {
        case .bookNotFound   : return "Book 엔티티를 찾을 수 없습니다."
        case .historyNotFound: return "BookHistory 엔티티가 연결되어 있지 않습니다."
            
        case .fetchFailed(let err):
            return "Core Data fetch 실패: \(err.localizedDescription)"
        case .saveFailed(let err):
            return "Core Data save 실패: \(err.localizedDescription)"
        }
    }
}


extension CoreDataManager {
    // MARK: - Public entry point
    /// Book, BookHistory, Review 세 가지를 한꺼번에 부분 업데이트
    ///  - 모든 파라미터는 Optional → 넘겨준 것만 수정
    func update(
        bookId: String,
        bookPatch: BookPatch = .init(),
        historyPatch: BookHistoryPatch = .init(),
        reviewPatch: ReviewPatch = .init()
    ) async throws {
        try await PersistenceManager.shared.container.performBackgroundTask { context in
            // 1) Book
            guard let book = try self.fetchBook(by: bookId, in: context) else {
                throw CoreDataError.bookNotFound
            }
            bookPatch.apply(to: book)
            
            // 2) BookHistory (연결이 없다면 throw)
            guard let history = book.bookHistory else {
                throw CoreDataError.historyNotFound
            }
            historyPatch.apply(to: history)
            
            // 3) Review (없을 수도 있으므로 lazy-create 가능)
            let review = history.review ?? ReviewEntity(context: context)
            reviewPatch.apply(to: review)
            if history.review == nil {          // 양방향 연결 보강
                history.review = review
                review.bookHistory = history
            }
            
            // 4) 저장
            try self.saveContext(context)
        }
    }
}
// MARK: - Private helpers & Errors
private extension CoreDataManager {
    func fetchBook(by id: String, in context: NSManagedObjectContext) throws -> BookEntity? {
        let req = BookEntity.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "bookId == %@", id)
        return try context.fetch(req).first
    }
}










