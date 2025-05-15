//
//  FetchCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

extension CoreDataManager {
    

    
    // MARK: - Book
    /// bookId로 BookEntity 조회
    func fetchBook(by bookId: String) -> BookEntity? {
        let predicate = NSPredicate(format: "bookId == %@", bookId)
        return fetchBookEntities(predicate: predicate).first
    }

    /// 캐시를 활용한 Book 조회 (없으면 fetch를 통해 가져옴)
    func loadBook(by id: String) -> Book? {
        // 1. 캐시 확인
        if let cached = BookCache.shared.get(by: id) {
            return Book(entity: cached)
        }
        
        // 2. Core Data fetch
        if let entity = fetchBook(by: id) {
            BookCache.shared.store(entity)
            return Book(entity: entity)
        }
        
        return nil
    }
    
    /// 최근 30일 이내의 Book 목록
    func fetchBooksWithin30Days(from date: Date) -> [Book] {
        guard let startDate = Calendar.current.date(byAdding: .day, value: -30, to: date) else { return [] }
        
        let predicate = NSPredicate(
            format: "bookHistory.startDate >= %@ AND bookHistory.startDate <= %@",
            startDate as NSDate, date as NSDate
        )
        
        let sort = [NSSortDescriptor(key: "bookHistory.startDate", ascending: true)]
        let entities = fetchBookEntities(predicate: predicate, sortDescriptors: sort)
        
        // 캐시 저장 및 모델 변환
        return cacheAndConvert(entities)
    }

    /// 같은 달의 Book 목록
    func fetchBooksInSameMonth(as date: Date) -> [Book] {
        let calendar = Calendar.current
        guard
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
        else {
            return []
        }

        let predicate = NSPredicate(
            format: "bookHistory.startDate >= %@ AND bookHistory.startDate <= %@",
            startOfMonth as NSDate,
            endOfMonth as NSDate
        )
        
        let sort = [NSSortDescriptor(key: "bookHistory.startDate", ascending: true)]
        let entities = fetchBookEntities(predicate: predicate, sortDescriptors: sort)
        
        return cacheAndConvert(entities)
    }

    // MARK: - 공통 변환 및 캐시 저장
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
    private func cacheAndConvert(_ entities: [BookEntity]) -> [Book] {
        entities.forEach { BookCache.shared.store($0) }
        return entities.compactMap { Book(entity: $0) }
    }
    
    
    
    
    
    
    
    
    
    
    
    
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
