//
//  DeleteCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

extension CoreDataManager {
    // MARK: - Book 삭제
    func delete(bookId: String) async throws {
        try await PersistenceManager
            .shared
            .container
            .performBackgroundTask
        { context in
            // 1. BookEntity fetch
            let request = NSFetchRequest<BookEntity>(entityName: "BookEntity")
            request.predicate = NSPredicate(format: "bookId == %@", bookId)
            request.fetchLimit = 1
            
            do {
                guard let book = try context.fetch(request).first else {
                    throw CoreDataError.bookNotFound
                }
                
                // 2. 연결된 BookHistory 삭제
                if let history = book.bookHistory {
                    // 연결된 Review 삭제
                    if let review = history.review {
                        context.delete(review)
                    }
                    context.delete(history)
                }
                
                // 3. Book 삭제
                context.delete(book)
                
                // 4. 저장
                try self.saveContext(context)
                
            } catch let error as CoreDataError {
                throw error
            } catch {
                throw CoreDataError.fetchFailed(underlying: error)
            }
        }
    }
}

