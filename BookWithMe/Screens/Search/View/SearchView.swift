//
//  SearchView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

// MARK: - Main View
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            searchBar
            scrollView
        }
        // 화면 탭/드래그 시 키보드 내리기
        .onTapGesture { isFocused = false }
        .gesture(
            DragGesture()
                .onChanged { _ in if isFocused { isFocused = false } }
        )
        // 화면 등장 시 첫 검색 실행
        .task { viewModel.search() }
    }
}

// MARK: - UI
private extension SearchView {
    
    // MARK: Search Bar
    var searchBar: some View {
        HStack {
            TextField(
                Constants.searchPlaceholder,
                text: $viewModel.searchText
            )
            .padding()
            .background(Constants.searchBarBackgroundColor)
            .defaultCornerRadius()
            .overlay(clearButtonOverlay)
            .focused($isFocused)
            .submitLabel(.search)
            .onSubmit { viewModel.search() }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }

    // MARK: Clear Button
    var clearButtonOverlay: some View {
        HStack {
            Spacer()
            if !viewModel.searchText.isEmpty {
                Button {
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

    // MARK: Result List
    var scrollView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                // 결과가 없고, 로딩 중이 아닐 때 ‘빈 상태’ 메시지
                if viewModel.searchResult.isEmpty && !viewModel.isLoading {
                    Text("검색 결과가 없습니다.")
                        .foregroundStyle(.secondary)
                        .padding()
                }

                // 검색 결과 목록
                ForEach(viewModel.searchResult, id: \.id) { book in
                    bookRow(book)
                    // 마지막 셀이 보이면 추가 데이터 가져오기
                        .onAppear {
                            viewModel.loadNextPageIfNeeded(currentItem: book)
                        }
                }

                // 로딩 인디케이터
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
        }
        .defaultCornerRadius()
    }

    // MARK: Book Row
    @ViewBuilder
    private func bookRow(_ book: Book) -> some View {
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
        .buttonStyle(.plain)
    }
}


// MARK: - Constants
private extension SearchView {
    enum Constants {
        static let searchPlaceholder = "검색어를 입력해주세요"
        static let searchBarBackgroundColor  = Color.contentsBackground1
        static let horizontalPadding: CGFloat = 16
    }
}
