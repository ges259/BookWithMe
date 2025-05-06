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
        book.bookName = bookName
        book.imagePath = imagePath
        
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
        bookId: String,
        userId: String,
        status: String,
        startDate: Date,
        endDate: Date
    ) {
        let bookHistory = BookHistoryEntity(context: context)
        bookHistory.bookId = bookId
        bookHistory.userId = userId
        bookHistory.status = status
        bookHistory.startDate = startDate
        bookHistory.endDate = endDate
        
        // Book과 BookHistory
        bookHistory.relationship = book
        
        do {
            try context.save()
        } catch {
            print("Error saving BookHistory: \(error)")
        }
    }
    
    // Review 생성
    func createReview(
        book: BookEntity,
        bookId: String,
        userId: String,
        reviewSummary: String,
        reviewDetail: String
    ) {
        let review = ReviewEntity(context: context)
        review.bookId = bookId
        review.userId = userId
        review.reviewSummary = reviewSummary
        review.reviewDetail = reviewDetail
        review.createdAt = Date()  // 현재 시간으로 설정
        
        review.relationship = book
        
        do {
            try context.save()
        } catch {
            print("Error saving Review: \(error)")
        }
    }
}

