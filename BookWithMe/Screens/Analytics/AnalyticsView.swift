//
//  AnalyticsView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct AnalyticsView: View {
    
    let bookArray: [String] = [
        "book7",
        "book8",
        "book9",
        "book10",
        "book11",
        "book12",
    ]
    
    let statusArray: [String] = [
        "recommended",
        "recommended",
        "reading",
        "reading",
        "reading",
        "completed"
    ]
    
    var body: some View {
        Button {
            for integer in 0...5 {
                let bookData = CoreDataManager.shared.createBook(
                    bookId: self.bookArray[integer],
                    bookName: self.bookArray[integer],
                    imagePath: self.bookArray[integer]
                )
                CoreDataManager
                    .shared
                    .createBookHistory(
                        book: bookData!,
                        status: self.statusArray[integer],
                        startDate: Date(),
                        endDate: Date())
            }
            
            
        } label: {
            Text("저장")
        }

    }
}

#Preview {
    AnalyticsView()
}
