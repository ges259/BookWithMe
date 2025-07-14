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
    
    /*
     1. 월요일인지 확인
        - 월요일이 아니라면 return
     2. 월요일이라면, 최근 10개의 책을 가져오기
     3. BookPrefs와 함께 AI를 통해 책을 가져오기
     */
//    func checkRecommendation(books: [Book]) {
        // 월요일인지 확인, 월요일이 아니라면 return
//        guard Date.isMonday() else { return }
//    }
    
    func fetchAIRecommendations() {
        Task {
            let books = await BookRecommender
                .shared
                .fetchRecommendedBooks(
                    recentBooks: [],
                    prefs: self.bookPrefs
                )
            
            // 책에 있는 history.status를 .recommended로 바꿈
            let wishlistBooks = self.booksChangeToRecommend(books)
            
            DispatchQueue.main.async {
                // 책을 캐시에 저장
                wishlistBooks.forEach { book in
                    self.store(book)
                }
            }
        }
    }
    
    private func booksChangeToRecommend(_ books: [Book]) -> [Book] {
        // status를 .wishlist로 바꿈
        let wishlistBooks = books.map { book -> Book in
            var b = book
            b.history.status = .recommended
            return b
        }
        return wishlistBooks
    }
}
