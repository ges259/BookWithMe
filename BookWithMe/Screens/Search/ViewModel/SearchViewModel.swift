//
//  SearchViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    var searchResult: [SearchCellViewModel] = []
    
    // 예시용 함수 - 나중에 검색 로직 연결 가능
    func searchBooks() {
        print("🔍 검색어: \(searchText)")
    }
}
