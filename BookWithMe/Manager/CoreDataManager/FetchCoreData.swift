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
//        static let bookHistoryStartDatePredicate = "bookHistory.startDate >= %@ AND bookHistory.startDate < %@"
        static let bookHistoryStartDateSort = NSSortDescriptor(
            key: "bookHistory.startDate",
            ascending: true
        )
    }
    
    // MARK: - Book 리스트
    func fetchBooksForMonth(containing date: Date = Date()) -> [Book] {
        let entities = fetchBookEntities(
            // MARK: - Fix
            // predicate를 통해 날짜를 필터링 할 수 있음 -> 추후 업데이트
            // predicate: datePredicateForMonth(containing: date),
            predicate: nil,
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

//    // MARK: - 날짜 Predicate
//    private func datePredicateForMonth(containing date: Date) -> NSPredicate? {
//        let calendar = Calendar.current
//
//        guard
//            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
//            let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)
//        else { return nil }
//
//        return NSPredicate(
//            format: Constants.bookHistoryStartDatePredicate,
//            startOfMonth as NSDate,
//            startOfNextMonth as NSDate
//        )
//    }
}
