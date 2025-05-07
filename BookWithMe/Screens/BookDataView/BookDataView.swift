//
//  BookDataView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

struct BookDataView: View {
    private let viewModel: BookDataViewModel = BookDataViewModel(book: Book.DUMMY_BOOK)
    
    var body: some View {
        VStack {
            self.scrollView
            self.bottomButton
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.baseBackground)
    }
}

private extension BookDataView {
    var scrollView: some View {
        return ScrollView {
            VStack(spacing: 12){
                self.bookDataHeaderView
                self.bottomVStack
                Spacer()
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
        .defaultShadow()
        .padding(.horizontal)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .top
        )
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
    }
    
    var bottomButton: some View {
        return Button {
            print("bottomButton_Tapped")
        } label: {
            Text("나의 책장에 저장하기")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 120)
        .background(Color.baseButton)
        .roundedTopCorners()
        .defaultShadow()
    }
}

#Preview {
    BookDataView()
}
