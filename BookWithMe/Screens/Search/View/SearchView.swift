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
        NavigationStack {
            
            VStack {
                searchBar
                scrollView
                Spacer()
            }
            .gesture(
                SimultaneousGesture(
                    TapGesture().onEnded { isFocused = false },
                    DragGesture().onChanged { _ in if isFocused { isFocused = false } }
                )
            )
        }
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
            .onChange(of: viewModel.searchText) { newValue in
                viewModel.searchBooks()
            }
        }
        .padding(.horizontal)
    }

    var clearButtonOverlay: some View {
        HStack {
            Spacer()
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .frame(width: 30, height: 30)
                        .foregroundColor(.contentsBackground2)
                }
                .padding(.trailing, 8)
            }
        }
    }
    
    var scrollView: some View {
        return ScrollView(showsIndicators: false){
            LazyVStack {
                self.bookDummy()
                self.bookDummy()
                self.bookDummy()
                self.bookDummy()
                self.bookDummy()
                self.bookDummy()
                self.bookDummy()
                self.bookDummy()
                self.bookDummy()
            }
        }
        .defaultCornerRadius()
    }
    
    func bookDummy() -> BookDataHeaderView {
        return BookDataHeaderView(book: Book.DUMMY_BOOK, size: .small, isShadow: false)
    }
}



//#Preview {
//    SearchView(viewModel: SearchViewModel())
//}
