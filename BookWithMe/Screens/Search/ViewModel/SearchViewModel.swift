//
//  SearchViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var searchResult: [Book] = []
    private var page: Int = 1
    
//    let bookAPIManager: BookAPIManager  = BookAPIManager.shared
    
    
    
    
//    // MARK: - 뷰 모델(or 컨트롤러)에서 호출
//    func searchBooks(isMore: Bool) {
//        
//        let searchPage: Int = isMore ? self.page + 1 : self.page
//        
//        print("🔍 검색어: \(searchText) / searchPage: \(searchPage)")
//        
//        Task {
//            do {
//                let data = try await bookAPIManager.fetchBooksAPI(
//                    byTitle: searchText,
//                    page: searchPage
//                )
//                self.searchResult = data
//                
//                
//                
//            } catch let error {
//                print("DEBUG: \(error.localizedDescription)")
//            }
//        }
//    }
//    var query: String = ""
    /// 로딩 상태
    var isLoading: Bool = false
    /// 에러 메시지
    var errorMessage: String?
    /// 검색 결과 도서 배열
//    var books: [Book] = [] {
//        didSe
//    }
    
    // 불편한
    /// 검색 요청 실행
    @MainActor
    func search() {
        Task {
            let term = searchText.trimmingCharacters(in: .whitespaces)
            guard !term.isEmpty else { return }

            isLoading = true
            errorMessage = nil

            let results = await AladinAPI.searchBooks(query: term, wantCount: 5)
            searchResult = results

            isLoading = false
        }
    }
}
