//
//  SearchView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

private enum SearchViewConstants {
    static let searchPlaceholder = "검색어를 입력해주세요"
    static let searchBarBackgroundColor = Color.contentsBackground1
}


// MARK: - Main View
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            self.searchBar
            self.scrollView
//            Spacer()
        }
        .gesture(
            SimultaneousGesture(
                TapGesture().onEnded { isFocused = false },
                DragGesture()
                    .onChanged { _ in
                        if isFocused { isFocused = false }
                    }
            )
        )
    }
}

// MARK: - Subviews
private extension SearchView {
    var searchBar: some View {
        HStack {
            TextField(SearchViewConstants.searchPlaceholder,
                      text: $viewModel.searchText)
            .padding()
            .background(SearchViewConstants.searchBarBackgroundColor)
            .defaultCornerRadius()
            .overlay(clearButtonOverlay)
            .focused($isFocused)
            .submitLabel(.search) // 키보드에 "검색" 표시
            .onSubmit { // 검색 버튼을 누른 후, 액션
                viewModel.searchBooks(isMore: false)
            }
        }
        .padding(.horizontal)
    }

    var clearButtonOverlay: some View {
        HStack {
            Spacer()
            if !viewModel.searchText.isEmpty {
                Button {
                    // 검색어를 초기화
                    viewModel.searchText = ""
                } label: {
                    Image.searchXmark
                        .frame(width: 30, height: 30)
                        .foregroundColor(.contentsBackground2)
                }
                .padding(.trailing, 8)
            }
        }
    }
    
    var scrollView: some View {
        return ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(
                    self.viewModel.searchResult,
                    id: \.id
                ) { book in
                    NavigationLink {
                        BookDataView(
                            viewModel: BookDataViewModel(
                                bookCache: BookCache.shared, 
                                coreDataManager: CoreDataManager.shared,
                                book: book
                            )
                        )
                    } label: {
                        BookDataHeaderView(
                            book: book,
                            size: .small,
                            isShadow: false
                        )
                    }
                    .buttonStyle(.plain) // 기본 효과 제거 (선택)
                }
            }
        }
        .defaultCornerRadius()
    }
}

//#Preview {
//    SearchView(viewModel: SearchViewModel())
//}
