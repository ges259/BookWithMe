//
//  BookDataView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

struct BookDescriptionView: View {
    
    let book: Book
    @State var descriptionMode: ViewModeType
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 12){
                    self.bookDataHeaderView
                    
                    if self.isShowinigBottomVStack {
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
        .background(self.isbaseButtonColor)
        .padding(.horizontal)
    }
}
    
// MARK: - UI
private extension BookDescriptionView {
    private var bookDataHeaderView: some View {
        BookDataHeaderView(
            book: book,
            size: .medium,
            isShadow: false
        )
        .padding(.horizontal, -16)
    }

    private var bottomVStack: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("책 소개")
                .font(.title2)
            Text(book.description)
                .font(.caption)
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 25)
    }
}


// MARK: - UI 계산
private extension BookDescriptionView {
    var isShowinigBottomVStack: Bool {
        return descriptionMode == .detail || descriptionMode == .preview
    }
    
    var isbaseButtonColor: Color {
        return self.descriptionMode == .detail
        ? Color.baseButton
        : Color.baseBackground
    }
    
}

#Preview {
    BookDescriptionView(
        book: Book.DUMMY_BOOK,
        descriptionMode: .preview
    )
}



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
