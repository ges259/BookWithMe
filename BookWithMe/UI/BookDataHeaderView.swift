//
//  BookDataHeaderView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

struct BookDataHeaderView: View {
    private let book: Book
    private let size: BookCardSize
    private let isShadow: Bool
    
    init(book: Book, size: BookCardSize, isShadow: Bool) {
        self.book = book
        self.size = size
        self.isShadow = isShadow
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            BookCardView(imageURL: book.imageString, size: self.size)
            self.rightVStack
            Spacer()
        }
        .padding()
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
        .if(isShadow) { $0.defaultShadow() }
        .padding(.horizontal)
    }
    
    private var rightVStack: some View {
        return VStack(alignment: .leading, spacing: 8) {
            Text(book.bookName)
                .font(.system(size: self.size.titleSize,
                              weight: .semibold))

            Text(book.bookAuthor)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.vertical)
    }
}


//#Preview {
//    BookDataHeaderView(book: Book.DUMMY_BOOK, )
//}
