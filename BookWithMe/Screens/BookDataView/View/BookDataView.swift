//
//  BookDataView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/8/25.
//

import SwiftUI
import BottomSheet
import HorizonCalendar

struct BookDataView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: BookDataViewModel
    
    
    var body: some View {
        VStack(spacing: 10) {
            // 상단 '책 설명' 화면
            self.bookDescriptionView
            
            // 프리뷰 모드가 아닐 때,
            // 중간의 '나의 기록' 화면
            if self.viewModel.isEditMode {
                self.bodyVStack
            }
            
            Spacer()
            // 프리뷰 모드일 때,
            // 하단의 '하단 버튼'
            if !self.viewModel.isEditMode {
                self.bottomButton
            }
        }
        // 뷰 body 내부
        .confirmationAlert(for: $viewModel.alertType)
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.baseBackground)
        .bottomSheet(
            bottomSheetPosition: self.$viewModel.sheetState,
            switchablePositions: [.hidden, .dynamic]
        ) {
            self.moveToBottomSheet
                .safeAreaPadding(.bottom)
                .bottomSheetGesture {
                    self.viewModel.sheetState = .hidden
                }
        }
        .customAnimation(self.viewModel.selectedRow == .summary ? nil : .default)
        .dragIndicatorColor(Color.white)
        .customBackground(Color.baseButton.cornerRadius(30))
        .enableSwipeToDismiss()
        .enableTapToDismiss()
        .toolbar {
            self.buildToolbarItems()
        }
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled(true)
    }
}



// MARK: - UI
private extension BookDataView {
    
    // MARK: - 왼쪽 네비게이션 바 아이템
    var leadingNavigationItem: some View {
        Button {
            
            if self.viewModel.isDiff() {
                self.viewModel.alertType = .unsavedChanges {
                    self.viewModel.reset()
                    self.dismiss()
                }
            } else {
                self.dismiss()
            }
            
        } label: {
            // 왼쪽 화살표 아이콘
            Image.arrowLeft
                .foregroundColor(.primary) // 아이콘 색상
        }
    }
    
    
    var trailingNavigationItem: some View {
        return HStack {
            self.saveToolbarItem
            self.deleteToolbarItem
        }
    }

    /// 툴바를 생성하는 코드
    @ToolbarContentBuilder
    func buildToolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            self.leadingNavigationItem
        }
        if self.viewModel.isEditMode {
            ToolbarItem(placement: .navigationBarTrailing) {
                self.trailingNavigationItem
            }
        }
    }
    /// UI - 책 설명 뷰
    var bookDescriptionView: some View {
        return BookDescriptionView(
            book: self.viewModel.book,
            descriptionMode: self.$viewModel.descriptionMode
        )
        .onTapGesture {
            self.viewModel.updateSheetState(row: .description)
        }
    }
    
    /// UI - '나의 기록'을 보여주는 테이블
    var bodyVStack: some View {
        return VStack(spacing: 0) {
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
    
    /// UI - 테이블의 헤더 역할
    var headerView: some View {
        return HeaderTitleView(
            title: "나의 기록",
            appFont: .bookDataTitle
        )
        .padding()
    }
    
    /// UI - 테이블의 행의 데이터(UI 및 타이틀)를 설정하는 함수
    func rowTitle(_ row: BookInfoRow) -> some View{
        return RowTitleView(
            title: row.title,
            isFirstCell: row.isFirstCell
        )
    }
    
    /// UI - 테이블의 Book 및 BookHistory의 정보를 설정하는 함수
    @ViewBuilder
    func detailText(_ row: BookInfoRow) -> some View {
        switch row {
        case .rating:
            StarView(starViewStyle: .custom(), 
                     rating: $viewModel.book.history.review.rating
            )
            
        default:
            RowDetailTextView(detatilText: self.viewModel.value(for: row))
        }
    }
    
    /// UI - 하단 버튼을 설정하는 함수
    var bottomButton: some View {
        return Button {
            print("bottomButton_Tapped")
            
            self.viewModel.turnToEditMode()
        } label: {
            Text("나의 책장에 저장하기")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 120)
        .background(Color.baseButton)
        .defaultCornerRadius(corners: .top, 35)
        .defaultShadow()
        .transition(.move(edge: .bottom))
    }
    
    var saveToolbarItem: some View {
        return Button("저장") {
            self.viewModel.saveBook()
        }
        .foregroundColor(.black)
    }
//    var deleteToolbarItem: some View {
//        return Button("삭제") {
//            self.viewModel.isShowingAlert = true
//        }
//        .foregroundColor(.red)
//        .confirmationAlert(
//            isPresented: $viewModel.isShowingAlert,
//            type: .deleteBook {
//                // 코어데이터에서 책 삭제
//                self.viewModel.deleteBook()
//                // 삭제 후 뒤로 가기
//                self.dismiss()
//            }
//        )
//    }
    
    var deleteToolbarItem: some View {
        Button("삭제") {
//            viewModel.alertType = .deleteBook {
//                viewModel.deleteBook()
//                dismiss()
//            }
        }
        .foregroundColor(.red)
    }
}







// MARK: - 화면 이동
extension BookDataView {
    @ViewBuilder
    var moveToBottomSheet: some View {
        switch self.viewModel.selectedRow {
        case .status:
            HistoryStatusView(
                bottomSheetPosition: $viewModel.sheetState,
                selectedStatus: $viewModel.book.history.status
            )
        case .startDate:
            HistoryTermView(
                startDate: $viewModel.book.history.startDate,
                endDate: $viewModel.book.history.endDate,
                selectionMode: .start
            )
        case .endDate:
            HistoryTermView(
                startDate: $viewModel.book.history.startDate,
                endDate: $viewModel.book.history.endDate,
                selectionMode: .end
            )
            
        case .rating:
            HistoryRatingView(
                bottomSheetPosition: $viewModel.sheetState,
                rating: $viewModel.book.history.review.rating
            )
            
        case .summary:
            HistoryTextFieldView(
                bottomSheetPosition: $viewModel.sheetState,
                text: Binding(
                    get: { viewModel.book.history.review.summary ?? "" },
                    set: { viewModel.book.history.review.summary = $0 }
                )
            )
        case .description:
            BookDescriptionView(
                book: self.viewModel.book,
                descriptionMode: .constant(.preview)
            )
        default:
            EmptyView()
        }
    }
}

//
//#Preview {
//    BookDataView(
//        viewModel: BookDataViewModel(
//            bookCache: BookCache.shared,
//            book: Book.DUMMY
//        )
//    )
//}
