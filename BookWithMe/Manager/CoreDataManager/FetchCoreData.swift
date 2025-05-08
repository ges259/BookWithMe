//
//  FetchCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

extension CoreDataManager {
    
    // MARK: - Id 조회
    // Book 조회 (bookId로 조회)
    func fetchBook(
        by bookId: String
    ) -> BookEntity? {
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
    func fetchReview(
        for bookId: String
    ) -> [ReviewEntity] {
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
    func fetchBookHistory(
        for userId: String
    ) -> [BookHistoryEntity] {
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
    
    
    
    
    
    // MARK: - 날짜순 조회
    ///
    func fetchBookHistory(
        from startDate: Date,
        to endDate: Date
    ) -> [BookHistoryEntity] {
        let request: NSFetchRequest<BookHistoryEntity> = BookHistoryEntity.fetchRequest()
        
        // startDate ~ endDate 사이인 BookHistory를 조회
        request.predicate = NSPredicate(
            format: "startDate >= %@ AND endDate <= %@",
            startDate as NSDate,
            endDate as NSDate
        )
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Error fetching BookHistory by date: \(error)")
            return []
        }
    }
    
    func fetchRecentBookHistories(
        until targetDate: Date
    ) -> [BookHistoryEntity] {
        let request: NSFetchRequest<BookHistoryEntity> = BookHistoryEntity.fetchRequest()
        
        // targetDate 이전(포함)인 데이터만 조회
        request.predicate = NSPredicate(
            format: "startDate <= %@",
            targetDate as NSDate
        )
        
        // 최근 날짜 순으로 정렬
        request.sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: false)
        ]
        
        // 최대 20개 제한
        request.fetchLimit = 20

        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Error fetching recent BookHistories: \(error)")
            return []
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchReviews(
        after date: Date
    ) -> [ReviewEntity] {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "createdAt >= %@", date as NSDate)
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Error fetching Review by date: \(error)")
            return []
        }
    }
}
