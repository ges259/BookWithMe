//
//  BookDataView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/8/25.
//

import SwiftUI
import BottomSheet

struct BookDataView: View {
    @State var viewModel: BookDataViewModel = BookDataViewModel(book: Book.DUMMY_BOOK)

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
        .dragIndicatorColor(Color.white)
        .customBackground(Color.baseButton.cornerRadius(30))
        .enableSwipeToDismiss()
        .enableTapToDismiss()
    }
}



// MARK: - UI

private extension BookDataView {
    
    // MARK: - 책 설명
    var bookDescriptionView: some View {
        return BookDescriptionView(
            book: Book.DUMMY_BOOK,
            viewModel: self.viewModel
        )
        .onTapGesture {
            self.viewModel.updateSheetState(row: .description)
        }
    }
    
    // MARK: - 나의 기록
    var bodyVStack: some View {
        return VStack(spacing: 0) {
            // 헤더
            self.header
 
            //
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
    var header: some View {
        return HeaderTitleView(
            title: "나의 기록",
            appFont: .bookDataTitle,
            showChevron: false
        )
        .frame(height: 70)
        .padding(.horizontal)
    }
    
    func rowTitle(_ row: BookInfoRow) -> some View {
        return Text(row.title)
            .frame(width: labelWidth,
                   height: 50,
                   alignment: .leading)
            .padding(.horizontal, 20)
            .background(Color.contentsBackground2)
            .font(.subheadline)
            .foregroundColor(.black)
            .if(row == .status) { $0.roundedTopTrailingCorners() }
        
    }
    func detailText(_ row: BookInfoRow) -> some View {
        return Text(self.viewModel.value(for: row))
            .font(.body)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 50)
    }
    
    
    
    // MARK: - 하단 버튼
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
        .roundedTopCorners()
        .defaultShadow()
        .transition(.move(edge: .bottom))
    }
}







// MARK: - 화면 이동
private extension BookDataView {
    @ViewBuilder
    var moveToBottomSheet: some View {
        switch self.viewModel.selectedRow {
        case .status:
            HistoryStatusView()
        case .period:
            TestView()
        case .rating:
            TestView()
        case .summary:
            TestView()
        case .tags:
            TestView()
        case .description:
            let viewModel: BookDataViewModel = BookDataViewModel(
                book: Book.DUMMY_BOOK,
                history: BookHistory.DUMMY_BOOKHISTORY)
            BookDescriptionView(
                book: Book.DUMMY_BOOK,
                viewModel: viewModel
            )
        default:
            TestView()
        }
    }
}








struct TestView: View {
    var body: some View {
        Text("Test View")
    }
}

#Preview {
    BookDataView()
}
