//
//  BookCache+AI.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

// MARK: - AIRecommendations
extension BookCache {
//    func checkRecommendation() {
        // 가져온 Book데이터 중에서 .recommended를 필터링 해서 가져옴
        
        // 가져온 데이터중 .recommended가 없다면, 데이터를 가져옴
        
        // .recommended가 있다면 날짜를 체크
        
        // 날짜가 오늘이라면, 아무행동도 하지 않음
        
        // 날짜가 오늘이 아니라면,
            // store에서 .recommended없애기
            // 새로운 데이터 가져오기
//    }
    
    func fetchAIRecommendations() {
        Task {
            let books = await BookRecommender
                .shared
                .fetchRecommendedBooks(
                    prefs: self.bookPrefs.toStringArrays(),
                    count: 5
                )
            
            // 책에 있는 history.status를 .recommended로 바꿈
            let wishlistBooks = self.booksChangeToRecommend(books)
            // 책을 캐시에 저장
            wishlistBooks.forEach {self.store($0) }
            
            print("________________________________________")
            dump(books)
            print("________________________________________")
        }
    }
    
    func booksChangeToRecommend(_ books: [Book]) -> [Book] {
        // status를 .wishlist로 바꿈
        let wishlistBooks = books.map { book -> Book in
            var b = book
            b.history.status = .recommended
            return b
        }
        return wishlistBooks
    }
}
