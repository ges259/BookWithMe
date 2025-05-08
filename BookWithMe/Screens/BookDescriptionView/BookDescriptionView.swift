//
//  BookDataView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

enum DescriptionMode {
    case preview
    case edit
}

struct BookDescriptionView: View {
    
    
    @State var viewModel: BookDescriptionViewModel
    
    
    var body: some View {
        VStack {
            self.scrollView
        }
        .background(Color.baseBackground)
    }
}

private extension BookDescriptionView {
    var scrollView: some View {
        return ScrollView {
            VStack(spacing: 12){
                self.bookDataHeaderView
                
                if self.viewModel.isPreviewMode {
                    self.bottomVStack
                }
//                    Spacer()
            }
        }
        .scrollDisabled(true)
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
        .defaultShadow()
        .padding(.horizontal)
    }
    
    var bookDataHeaderView: some View {
        return BookDataHeaderView(
            book: self.viewModel.book,
            size: .medium,
            isShadow: false
        )
        .padding(.horizontal, -16)
    }
    
    
    var bottomVStack: some View {
        return VStack(alignment: .leading, spacing: 12) {
            Text("책 소개")
                .font(.title2)
            Text(self.viewModel.book.description)
                .font(.caption)
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 25)
    }
}

#Preview {
    BookDescriptionView(viewModel: BookDescriptionViewModel(book: Book.DUMMY_BOOK))
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
