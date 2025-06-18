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
    
    /// 최대 글자 수 (이 수를 넘어가면 …을 붙입니다)
    private static let maxTitleLength = 30
    
    init(book: Book, size: BookCardSize, isShadow: Bool) {
        self.book = book
        self.size = size
        self.isShadow = isShadow
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            BookCardView(imageURL: book.imageURL ?? "", size: self.size)
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
            Text(truncatedTitle)
                .font(.system(size: self.size.titleSize,
                              weight: .bold))

            Text(book.author)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.vertical)
    }
    
    /// 글자 수를 체크해서 잘라내고 …을 붙인 문자열을 반환
    private var truncatedTitle: String {
        if book.title.count > Self.maxTitleLength {
            let idx = book
                .title
                .index(book.title.startIndex,
                       offsetBy: Self.maxTitleLength
                )
            return String(book.title[..<idx]) + "..."
        } else {
            return book.title
        }
    }
}


//#Preview {
//    BookDataHeaderView(book: Book.DUMMY_BOOK, )
//}
