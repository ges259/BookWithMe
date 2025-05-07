//
//  AnalyticsView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AnalyticsView()
}


//final class BookDataViewModel {
final class BookDataViewModel {
    var book: Book = Book.DUMMY_BOOK
    init(book: Book) {
        self.book = book
    }
}
