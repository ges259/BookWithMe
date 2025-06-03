//
//  DeleteCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

extension CoreDataManager {
    // MARK: - Book 삭제 함수
    /// 주어진 bookId를 가진 Book 및 연관된 BookHistory, Review 데이터를 Core Data에서 삭제해요.
    func delete(bookId: String) async throws {
        try await PersistenceManager.shared.container.performBackgroundTask { context in
            // 1. BookEntity 가져오기
            let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
            request.predicate = NSPredicate(format: "bookId == %@", bookId)
            request.fetchLimit = 1
            
            do {
                guard let book = try context.fetch(request).first else {
                    // 해당 bookId의 책이 없으면 에러 던짐
                    throw CoreDataError.bookNotFound
                }

                // 2. 연관된 BookHistory 및 Review 삭제
                if let history = book.bookHistory {
                    if let review = history.review {
                        context.delete(review) // 먼저 리뷰 삭제
                    }
                    context.delete(history) // 그다음 히스토리 삭제
                }

                // 3. 책(BookEntity) 삭제
                context.delete(book)

                // 4. 변경사항 저장
                try self.saveContext(context)

            } catch let error as CoreDataError {
                throw error // 우리가 정의한 에러는 그대로 전달
            } catch {
                throw CoreDataError.deleteFailed(underlying: error)
            }
        }
    }
}

