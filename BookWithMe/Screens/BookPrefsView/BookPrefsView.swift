//
//  BookPrefsView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/30/25.
//

import SwiftUI
import BottomSheet

// Preference
struct BookPrefsView: View {
    @State var viewModel: BookPrefsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
  
            self.bodyTable
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.baseBackground)
        .bottomSheet(
            bottomSheetPosition: $viewModel.sheetState,
            switchablePositions: [.hidden, .dynamic]
        ) {
            self.moveToBottomSheet
                .safeAreaPadding(.bottom)
                .bottomSheetGesture {
                    self.viewModel.sheetState = .hidden
                }
        }
        .enableSwipeToDismiss()
        .enableTapToDismiss()

    }
}

// MARK: - UI
private extension BookPrefsView {
    /// UI - 테이블의 헤더 역할
    var headerView: some View {
        return HeaderTitleView(
            title: "추천 검색 설정",
            appFont: .bookDataTitle
        )
        .padding()
    }
    
    var bodyTable: some View {
        return LazyVStack(alignment: .leading, spacing: 0) {
            self.headerView
            // 테이블
            ForEach(self.viewModel.allCases) { row in
                HStack(alignment: .top, spacing: 20) {
                    self.rowTitle(row)
                    self.detailView(row)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.viewModel.updateSheetState(row: row)
                }
            }
        }
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
        .defaultShadow()
        .padding(.horizontal)
    }
    
    
    /// UI - 테이블의 행의 데이터(UI 및 타이틀)를 설정하는 함수
    func rowTitle(_ row: CustomPrefsType) -> some View {
        return RowTitleView(
            title: row.title,
            isFirstCell: row.isFirstCell,
            isLastCell: row.isLastCell
        )
    }
    
    
    func detailView(_ row: CustomPrefsType) -> some View {
        Group {
            if row.isHStackScroll {
                horizontalBookScroll
            } else {
                detailText(row)
            }
        }
    }
    /// UI - 테이블의 Book 및 BookHistory의 정보를 설정하는 함수
    func detailText(_ row: CustomPrefsType) -> some View {
        return RowDetailTextView(detatilText: self.viewModel.value(for: row))
    }
    var horizontalBookScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            // HStack
            LazyHStack(alignment: .top, spacing: 12) {
                // 테이블뷰 만들기
                ForEach(viewModel.bookArray, id: \.id) { book in
                    // 화면이동을 위한 NavigationLink
                    NavigationLink {
                        BookDataView(
                            viewModel: BookDataViewModel(
                                bookCache: BookCache.shared,
                                book: book
                            )
                        )
                    } label: {
                        // 보여질 이미지
                        BookCardView(
                            imageURL: book.imageURL,
                            size: .small
                        )
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}



// MARK: - 화면이동
private extension BookPrefsView {
    @ViewBuilder
    var moveToBottomSheet: some View {
        switch self.viewModel.selectedRow {
        case .language, .pageLength, .ageGroup, .readingPurpose:
            CustomPrefsAlert(type: self.viewModel.selectedRow)
        case .likedGenres, .dislikedGenres:
            Text("")
        }
    }
}



#Preview {
    BookPrefsView(viewModel: BookPrefsViewModel(bookCache: BookCache.shared))
}

