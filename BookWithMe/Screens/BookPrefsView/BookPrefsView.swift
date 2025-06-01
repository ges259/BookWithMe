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
        .dragIndicatorColor(Color.white)
        .customBackground(Color.baseButton.cornerRadius(30))
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
                    self.detailText(row)
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
            isFirstCell: row.isFirstCell
        )
    }
    
    /// UI - 테이블의 Book 및 BookHistory의 정보를 설정하는 함수
    func detailText(_ row: CustomPrefsType) -> some View {
        return RowDetailTextView(detatilText: self.viewModel.value(for: row))
    }
}



// MARK: - 화면이동
private extension BookPrefsView {
    @ViewBuilder
    var moveToBottomSheet: some View {
        CustomPrefsAlert(
            type: self.viewModel.selectedRow,
            bottomSheetPosition: self.$viewModel.sheetState, 
            // ↓ 싱글톤 속성을 Binding 으로 래핑
//            localPrefs: Binding(
//                get: { BookCache.shared.bookPrefs },
//                set: { BookCache.shared.bookPrefs = $0 }
//            )
            localPrefs: self.$viewModel.bookprefs
        )
    }
}



#Preview {
    BookPrefsView(viewModel: BookPrefsViewModel(bookCache: BookCache.shared))
}
