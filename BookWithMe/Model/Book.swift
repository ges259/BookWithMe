//
//  Book+Model.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct Book {
    let bookId: String
    let bookName: String
    let imageString: String
}

extension Book {
    static var DUMMY_BOOK: Book = Book(
        bookId: "bookId",
        bookName: "불편한 편의점",
        imageString: "불편한편의점_표지"
    )
}
