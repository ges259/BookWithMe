//
//  BookDataView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

struct BookDescriptionView: View {
    
    let fullBook: FullBook
    @Binding var descriptionMode: ViewModeType
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12){
                    self.bookDataHeaderView
                    
                    if self.descriptionMode == .preview {
                        self.bottomVStack
                    }
                }
            }
            .scrollDisabled(true)
            .fixedSize(horizontal: false, vertical: true)
            .background(Color.contentsBackground1)
            .defaultCornerRadius()
            .defaultShadow()
        }
        .background(Color.clear)
        .padding(.horizontal)
    }
}
    
// MARK: - UI
private extension BookDescriptionView {
    var bookDataHeaderView: some View {
        BookDataHeaderView(
            book: fullBook,
            size: .medium,
            isShadow: false
        )
        .padding(.horizontal, -16)
    }

    var bottomVStack: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("책 소개")
                .font(.title2)
            Text(fullBook.description)
                .font(.caption)
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 25)
    }
}

//#Preview {
//    let viewModel: BookDataViewModel = BookDataViewModel(
//        book: Book.DUMMY_BOOK)
//    
//    return BookDescriptionView(
//        book: Book.DUMMY_BOOK,
//        viewModel: viewModel
//    )
//}



/*
 
 - BookDescriptionView
 - EditBookView
 
 -- 화면 = [
    BookDataView
    BookHistoryView
    bottomButton
    ]
 
 -- 모드 = [
    PreviewMode (기본 모드, BookHistoryView 및 bottomButton 숨김)
    EditMode    (수정 모드, BookHistoryView 및 bottomButton 보임)
    ]
 
 */

