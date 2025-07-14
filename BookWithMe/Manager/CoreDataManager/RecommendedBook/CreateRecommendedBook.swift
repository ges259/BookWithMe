//
//  CreateRecommendedBook.swift
//  BookWithMe
//
//  Created by 계은성 on 7/14/25.
//

import Foundation

extension CoreDataManager {
//    // MARK: - 저장 함수
//    func saveRecommendedBooks(
//        _ books: [RecommendedBook],
//        context: NSManagedObjectContext
//    ) {
//        for book in books {
//            let entity = RecommendedBookEntity(context: context)
//            entity.id = book.id
//            entity.title = book.title
//            entity.date = book.date
//        }
//        
//        do {
//            try context.save()
//            print("✅ \(books.count)개의 추천 도서가 저장되었습니다.")
//        } catch {
//            print("❌ 도서 저장 실패: \(error.localizedDescription)")
//        }
//    }
//    
//    // MARK: - 조회 함수
//    func fetchAllRecommendedBooks(
//        context: NSManagedObjectContext
//    ) -> [RecommendedBook] {
//        let request: NSFetchRequest<RecommendedBookEntity> = RecommendedBookEntity.fetchRequest()
//
//        do {
//            let results = try context.fetch(request)
//            return results.map { entity in
//                RecommendedBook(
//                    id: entity.id,
//                    date: entity.date,
//                    title: entity.title
//                )
//            }
//        } catch {
//            print("❌ 도서 조회 실패: \(error.localizedDescription)")
//            return []
//        }
//    }
//    
//    // MARK: - 중복 제거 로직 (ISBN 기준 비교)
//    /// 기존 추천 도서들과 중복되는 ISBN13을 가진 책은 제외
//    func filterDuplicates(
//        from newBooks: [Book],
//        existing: [RecommendedBook]
//    ) -> [Book] {
//        let existingIDs = Set(existing.map { $0.id })
//        return newBooks.filter { !existingIDs.contains($0.id) }
//    }
}
