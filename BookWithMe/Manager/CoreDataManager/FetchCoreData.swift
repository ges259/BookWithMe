//
//  FetchCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

extension CoreDataManager {
    private struct Constants {
        // Predicates
        static let bookIdPredicateFormat = "bookId == %@"
        static let bookHistoryStartDatePredicate = "bookHistory.startDate >= %@ AND bookHistory.startDate <= %@"
        
        // Sort Descriptors
        static let bookHistoryStartDateSort = NSSortDescriptor(key: "bookHistory.startDate", ascending: true)
        
        // Date Related
        static let daysInPast: Int = 30
    }
    
    
    // MARK: - Book
    // 리스트: LightBook 배열
    func fetchLightBooksWithin30Days(from date: Date) -> [LightBook] {
        let entities = fetchBookEntities(
            predicate: datePredicateForLast30Days(from: date),
            sortDescriptors: [Constants.bookHistoryStartDateSort]
        )
        entities.forEach { BookCache.shared.store($0) }          // 캐싱
        return BookCache.shared.lightBooks(from: entities)       // 변환
    }

    // --- 내부 헬퍼 ---
    private func datePredicateForLast30Days(from date: Date) -> NSPredicate? {
        guard let start = Calendar.current.date(byAdding: .day,
                                                value: -Constants.daysInPast,
                                                to: date)
        else { return nil }

        return NSPredicate(format: Constants.bookHistoryStartDatePredicate,
                           start as NSDate, date as NSDate)
    }

    
    
    
    
    // 상세: FullBook
    func loadFullBook(by id: String) -> FullBook? {
        // 1) 캐시 hit
        if let full = BookCache.shared.fullBook(by: id) { return full }

        // 2) fetch → 캐시 → 변환
        guard let entity = fetchBook(by: id) else { return nil }
        BookCache.shared.store(entity)
        return FullBook(entity: entity)
    }
    /// bookId로 BookEntity 조회
    func fetchBook(by bookId: String) -> BookEntity? {
        let predicate = NSPredicate(format: Constants.bookIdPredicateFormat, bookId)
        return fetchBookEntities(predicate: predicate).first
    }
    
    
    
    // MARK: - Book 공통 함수
    /// Private 공통 fetch 메서드
    private func fetchBookEntities(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [BookEntity] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(request)
        } catch {
            print("⚠️ Fetch error: \(error)")
            return []
        }
    }

//    private func cacheAndConvert(_ entities: [BookEntity]) -> [Book] {
//        entities.forEach { BookCache.shared.store($0) }
//        return entities.compactMap { Book(entity: $0) }
//    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - BookHistory
    // BookHistory 조회 (userId로 조회)
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
            print("_________fetchBookHistory_________")
            dump(result)
            print("__________________________________")
            
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
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Review
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
