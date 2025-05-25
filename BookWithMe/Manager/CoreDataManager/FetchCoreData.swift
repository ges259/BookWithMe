//
//  FetchCoreData.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
import CoreData

extension CoreDataManager {
    // MARK: - Constants
    private struct Constants {
        static let bookIdPredicateFormat = "bookId == %@"
        static let bookHistoryStartDatePredicate = "bookHistory.startDate >= %@ AND bookHistory.startDate < %@"
        static let bookHistoryStartDateSort = NSSortDescriptor(key: "bookHistory.startDate", ascending: true)
    }

    // MARK: - Book 리스트
    func fetchBooksForMonth(containing date: Date) -> [Book] {
        let entities = fetchBookEntities(
            predicate: datePredicateForMonth(containing: date),
            sortDescriptors: [Constants.bookHistoryStartDateSort]
        )

        let books = entities.map { Book(entity: $0) }
        books.forEach { BookCache.shared.store($0) }
        return books
    }

    // MARK: - Book 상세
    func loadBook(by id: String) -> Book? {
        if let cached = BookCache.shared.book(id: id) {
            return cached
        }

        guard let entity = fetchBook(by: id) else { return nil }
        let book = Book(entity: entity)
        BookCache.shared.store(book)
        return book
    }

    private func fetchBook(by bookId: String) -> BookEntity? {
        let predicate = NSPredicate(format: Constants.bookIdPredicateFormat, bookId)
        return fetchBookEntities(predicate: predicate).first
    }

    // MARK: - 공통 fetch
    private func fetchBookEntities(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [BookEntity] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        // 🚀 관계 미리 불러오기: N+1 문제 방지
        request.relationshipKeyPathsForPrefetching = [
            #keyPath(BookEntity.bookHistory),
            #keyPath(BookEntity.bookHistory.review)
        ]

        do {
            return try context.fetch(request)
        } catch {
            print("⚠️ BookEntity fetch 실패: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - 날짜 Predicate
    private func datePredicateForMonth(containing date: Date) -> NSPredicate? {
        let calendar = Calendar.current

        guard
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
            let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)
        else { return nil }

        return NSPredicate(
            format: Constants.bookHistoryStartDatePredicate,
            startOfMonth as NSDate,
            startOfNextMonth as NSDate
        )
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
