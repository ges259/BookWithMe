//
//  CoreDataManager.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
}


// MARK: - Create
extension CoreDataManager {
    // Book 생성
    func createBook(
        bookId: String,
        bookName: String,
        imagePath: String,
        context: NSManagedObjectContext
    ) {
        let book = BookEntity(context: context)
        book.bookId = bookId
        book.bookName = bookName
        book.imagePath = imagePath
        
        do {
            try context.save()  // 데이터를 저장
        } catch {
            print("Error saving Book: \(error)")
        }
    }

    // Review 생성
    func createReview(
        bookId: String,
        userId: String,
        reviewSummary: String,
        reviewDetail: String,
        context: NSManagedObjectContext
    ) {
        let review = ReviewEntity(context: context)
        review.bookId = bookId
        review.userId = userId
        review.reviewSummary = reviewSummary
        review.reviewDetail = reviewDetail
        review.createdAt = Date()  // 현재 시간으로 설정
        
        do {
            try context.save()
        } catch {
            print("Error saving Review: \(error)")
        }
    }

    // BookHistory 생성
    func createBookHistory(bookId: String, userId: String, status: String, startDate: Date, endDate: Date, context: NSManagedObjectContext) {
        let bookHistory = BookHistoryEntity(context: context)
        bookHistory.bookId = bookId
        bookHistory.userId = userId
        bookHistory.status = status
        bookHistory.startDate = startDate
        bookHistory.endDate = endDate
        
        // 책과의 관계 설정 (bookId에 해당하는 책을 찾음)
        if let book = fetchBook(by: bookId, context: context) {
            bookHistory.relationship = book
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving BookHistory: \(error)")
        }
    }
}










// MARK: - Read
extension CoreDataManager {
    // Book 조회 (bookId로 조회)
    func fetchBook(by bookId: String, context: NSManagedObjectContext) -> BookEntity? {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "bookId == %@", bookId)
        
        do {
            let result = try context.fetch(request)
            return result.first
        } catch {
            print("Error fetching Book: \(error)")
            return nil
        }
    }
    
    // Review 조회 (bookId로 조회)
    func fetchReview(for bookId: String, context: NSManagedObjectContext) -> [ReviewEntity] {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "bookId == %@", bookId)
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Error fetching Review: \(error)")
            return []
        }
    }
    
    // BookHistory 조회 (userId로 조회)
    func fetchBookHistory(for userId: String, context: NSManagedObjectContext) -> [BookHistoryEntity] {
        let request: NSFetchRequest<BookHistoryEntity> = BookHistoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Error fetching BookHistory: \(error)")
            return []
        }
    }
    
}





// MARK: - Update
extension CoreDataManager {
    // Book 업데이트
    func updateBook(bookId: String, newBookName: String, newImagePath: String, context: NSManagedObjectContext) {
        if let book = fetchBook(by: bookId, context: context) {
            book.bookName = newBookName
            book.imagePath = newImagePath
            
            do {
                try context.save()
            } catch {
                print("Error updating Book: \(error)")
            }
        } else {
            print("Book not found")
        }
    }
    
    // Review 업데이트
    func updateReview(reviewId: String, newReviewSummary: String, newReviewDetail: String, context: NSManagedObjectContext) {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "reviewId == %@", reviewId)
        
        do {
            if let review = try context.fetch(request).first {
                review.reviewSummary = newReviewSummary
                review.reviewDetail = newReviewDetail
                
                try context.save()
            } else {
                print("Review not found")
            }
        } catch {
            print("Error updating Review: \(error)")
        }
    }
}



// MARK: - Delete
extension CoreDataManager {
    // Book 삭제
    func deleteBook(by bookId: String, context: NSManagedObjectContext) {
        if let book = fetchBook(by: bookId, context: context) {
            context.delete(book)
            
            do {
                try context.save()
            } catch {
                print("Error deleting Book: \(error)")
            }
        } else {
            print("Book not found")
        }
    }
    
    // Review 삭제
    func deleteReview(by reviewId: String, context: NSManagedObjectContext) {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "reviewId == %@", reviewId)
        
        do {
            if let review = try context.fetch(request).first {
                context.delete(review)
                try context.save()
            } else {
                print("Review not found")
            }
        } catch {
            print("Error deleting Review: \(error)")
        }
    }
    
    // BookHistory 삭제
    func deleteBookHistory(by bookHistoryId: String, context: NSManagedObjectContext) {
        let request: NSFetchRequest<BookHistoryEntity> = BookHistoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "bookHistoryId == %@", bookHistoryId)
        
        do {
            if let bookHistory = try context.fetch(request).first {
                context.delete(bookHistory)
                try context.save()
            } else {
                print("BookHistory not found")
            }
        } catch {
            print("Error deleting BookHistory: \(error)")
        }
    }
}










// MARK: - PersistenceController
final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        // 여기에 모델 이름을 너의 .xcdatamodeld 파일 이름과 동일하게 설정해야 함
        container = NSPersistentContainer(name: "CoreData") // <- 모델 이름 바꿔줘

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("❌ Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
