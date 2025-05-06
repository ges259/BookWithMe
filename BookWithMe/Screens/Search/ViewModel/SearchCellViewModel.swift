//
//  SearchCellViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

final class SearchCellViewModel {
    
    var book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    
    var imageUrl: String {
        return ""
    }
    
    var bookTitle: String {
        return "bookTitle"
    }
    var bookAuthor: String {
        return "bookAuthors"
    }
    
}
