//
//  DeleteCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

extension CoreDataManager {
    // Book 삭제
    func deleteBook(
        by bookId: String
    ) {
//        if let book = fetchBook(by: bookId) {
//            context.delete(book)
//            
//            do {
//                try context.save()
//            } catch {
//                print("Error deleting Book: \(error)")
//            }
//        } else {
//            print("Book not found")
//        }
    }
    
    // Review 삭제
    func deleteReview(
        by reviewId: String
    ) {
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
    func deleteBookHistory(
        by bookHistoryId: String
    ) {
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

