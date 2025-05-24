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
    @State var startDate: Date? = Date()
    @State var endDate: Date? = nil
    
    
    @State var viewModel: BookDataViewModel
    

    private let labelWidth: CGFloat = 60
    
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
    }
}



// MARK: - UI

private extension BookDataView {
    
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
    func rowTitle(_ row: BookInfoRow) -> some View {
        return Text(row.title)
            .frame(width: labelWidth,
                   height: 50,
                   alignment: .leading)
            .padding(.horizontal, 20)
            .background(Color.contentsBackground2)
            .font(.subheadline)
            .foregroundColor(.black)
            .if(row == .status) { $0.defaultCornerRadius(corners: .topTrailing) }
    }
    
    /// UI - 테이블의 Book 및 BookHistory의 정보를 설정하는 함수
    func detailText(_ row: BookInfoRow) -> some View {
        return Text(self.viewModel.value(for: row) ?? "")
            .font(.body)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 50)
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
}







// MARK: - 화면 이동
extension BookDataView {
    @ViewBuilder
    var moveToBottomSheet: some View {
        switch self.viewModel.selectedRow {
        case .status:
            HistoryStatusView(
                selectedStatus: $viewModel.book.history.status
            )
        case .startDate:
            HistoryTermView(
                startDate: $viewModel.book.history.startDate,
                endDate: $viewModel.book.history.endDate,
                selectionMode: .start)
        case .endDate:
            HistoryTermView(
                startDate: $viewModel.book.history.startDate,
                endDate: $viewModel.book.history.endDate,
                selectionMode: .end)
            
        case .rating:
                HistoryRatingView(
                    rating: Binding(
                        get: { viewModel.book.history.review?.rating ?? 0 },
                        set: { viewModel.book.history.review?.rating = $0}
                    )
                )
        case .summary:
            HistoryTextFieldView(
                text: Binding(
                    get: { viewModel.book.history.review?.summary ?? "" },
                    set: { viewModel.book.history.review?.summary = $0 }
                )
            )
        case .tags:
            TestView2()
        case .description:
            BookDescriptionView(
                book: self.viewModel.book,
                descriptionMode: .constant(.preview)
            )
        default:
            TestView2()
        }
    }
}







struct TestView2: View {
    var body: some View {
        Text("Test View")
    }
}

#Preview {
    BookDataView(
        viewModel: BookDataViewModel(
            bookCache: BookCache.shared,
            book: Book.DUMMY
        )
    )
}
