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
}

extension CoreDataManager {
    // Book 생성
    func createBook(
        bookId: String,
        bookName: String,
        imagePath: String
    ) -> BookEntity? {
        let book = BookEntity(context: context)
        book.bookId = bookId
        
        book.title = "bookName"
        book.publisher = imagePath
        book.imageURL = "imageURL"
        book.bookDescription = "bookDescription"
        book.author = "author"
        
        
        do {
            try context.save()  // 데이터를 저장
            return book
        } catch {
            print("Error saving Book: \(error)")
            return nil
        }
    }


    // BookHistory 생성
    func createBookHistory(
        book: BookEntity,
        review: ReviewEntity,
        status: String,
        startDate: Date,
        endDate: Date
    ) {
        let bookHistory = BookHistoryEntity(context: context)
        bookHistory.status = status
        bookHistory.startDate = startDate
        bookHistory.endDate = endDate
        bookHistory.bookHistoryId = UUID().uuidString
        // Book과 BookHistory
        bookHistory.book = book
        bookHistory.review = review
        
        do {
            try context.save()
        } catch {
            print("Error saving BookHistory: \(error)")
        }
    }
    
    func createReview(
        bookHistory: BookHistoryEntity,
        bookId: String,
        reviewSummary: String,
        reviewDetail: String
    ) {
        let review = ReviewEntity(context: context)
        review.bookId = bookId
        review.reviewSummary = reviewSummary
        review.reviewDetail = reviewDetail
        review.updatedAt = Date()
        
        review.bookHistory = bookHistory  // Book 관계 연결

        // ✅ BookHistory에도 연결
        bookHistory.review = review

        do {
            try context.save()
        } catch {
            print("Error saving Review: \(error)")
        }
    }
    

    
    
    
    
    
    // BookHistory 생성
    func create_DUMMYCoreData(
        bookId: String,
        bookName: String,
        status: String
    ) {
        // Book
        let book = BookEntity(context: context)
        book.bookId = bookId
        book.title = "bookName"
        book.publisher = "imagePath"
        book.imageURL = "imageURL"
        book.bookDescription = "bookDescription"
        book.author = "author"
        
        
        // BookHistory
        let bookHistory = BookHistoryEntity(context: context)
        bookHistory.bookHistoryId = UUID().uuidString
        bookHistory.status       = status
        bookHistory.startDate    = Date()
        bookHistory.endDate      = Date()
        
//        
//        // Review
//        let review = ReviewEntity(context: context)
//        review.reviewId      = UUID().uuidString
//        review.rating        = Double(0)
//        review.reviewSummary = "summary"
//        review.reviewDetail  = "detail"
//        review.updatedAt     = Date()
//        
        
        book.bookHistory = bookHistory
        bookHistory.book    = book
//        bookHistory.review  = review
//        review.bookHistory  = bookHistory
        
        do {
            try context.save()
        } catch {
            print("Error saving BookHistory: \(error)")
        }
    }
    
    
    
    
    
    
    
    
    
    
}

