//
//  BookDataViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/8/25.
//

import Foundation

@Observable
final class BookDescriptionViewModel {
    
    var book: Book = Book.DUMMY_BOOK
    
    var descriptionMode: DescriptionMode = .preview
    
    
    var isPreviewMode: Bool {
        return self.descriptionMode == .preview
    }
    
    init(book: Book) {
        self.book = book
    }
    
    
    func descriptionModeToggle() {
        // MARK: - Fix
        if self.descriptionMode == .preview {
            self.descriptionMode = .edit
        } else {
            self.descriptionMode = .preview
        }
    }
}
