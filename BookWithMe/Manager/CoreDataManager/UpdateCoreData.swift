//
//  UpdateCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

extension CoreDataManager {
    // Book 업데이트
    func updateBook(
        bookId: String,
        newBookName: String,
        newImagePath: String
    ) {
        if let book = fetchBook(by: bookId) {
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
    func updateReview(
        reviewId: String,
        newReviewSummary: String,
        newReviewDetail: String
    ) {
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
