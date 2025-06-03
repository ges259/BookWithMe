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
    
    let bookAPIManager: BookAPIManager  = BookAPIManager.shared
    
    
    
    
    // MARK: - 뷰 모델(or 컨트롤러)에서 호출
    func searchBooks(isMore: Bool) {
        
        let searchPage: Int = isMore ? self.page + 1 : self.page
        
        print("🔍 검색어: \(searchText) / searchPage: \(searchPage)")
        
        Task {
            do {
                let data = try await bookAPIManager.fetchBooksAPI(
                    byTitle: searchText,
                    page: searchPage
                )
                self.searchResult = data
                
                
                
            } catch let error {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
}
