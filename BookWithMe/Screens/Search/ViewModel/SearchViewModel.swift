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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var page: Int = 1
    private var canLoadMore: Bool = true  // 더 불러올 수 있는지 플래그
    
    /// 새 키워드 검색 시 상태 초기화하고 1페이지를 로드
    @MainActor
    func search() {
        // 키워드가 바뀌면 페이지 초기화
        page = 1
        canLoadMore = true
        searchResult.removeAll()
        fetchPage()
    }
    
    /// 다음 페이지를 불러오기 (스크롤 바닥에서 호출)
    @MainActor
    func loadNextPageIfNeeded(currentItem item: Book) {
        guard let last = searchResult.last else { return }
        // 현재 item이 마지막 아이템이면 다음 페이지 요청
        if item.id == last.id && canLoadMore && !isLoading {
            page += 1
            fetchPage()
        }
    }
    
    /// 내부: 지정된 페이지를 서버에서 가져와 append
    private func fetchPage() {
        Task { @MainActor in
            isLoading = true
            errorMessage = nil
            
            let term = searchText.trimmingCharacters(in: .whitespaces)
            guard !term.isEmpty else {
                isLoading = false
                return
            }
            
            let results = await AladinAPI.searchBooks(
                query: term,
                page: page
            )
            print("____________________")
            dump(results)
            print("____________________")
            // 결과가 없으면 더 이상 불러올 필요 없음
            if results.isEmpty {
                canLoadMore = false
            } else {
                // 1페이지면 새로, 그 이후면 append
                if page == 1 {
                    searchResult = results
                } else {
                    searchResult.append(contentsOf: results)
                }
            }
            isLoading = false
        }
    }
}
