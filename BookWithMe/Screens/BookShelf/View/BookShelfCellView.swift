//
//  BookShelfCellView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

enum BookShelfUI {
    static let cardSize = CGSize(width: 80, height: 120)
    static let cornerRadius: CGFloat = 16
    static let horizontalSpacing: CGFloat = 12
    static let shadowRadius: CGFloat = 4
    static let shadowYOffset: CGFloat = 2
}




struct BookShelfCellView: View {
    var viewModel: BookShelfCellViewModel
    init(viewModel: BookShelfCellViewModel) {
        self.viewModel = viewModel
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            self.header
            self.horizontalBookScroll
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BookShelfUI.cornerRadius))
        .shadow(radius: 4, y: 2)
        .padding(.horizontal)
    }
}

private extension BookShelfCellView {
    var header: some View {
        HStack {
            Text(self.viewModel.title)
                .font(.headline)
                .foregroundStyle(.primary)
            Spacer()
            Image.chevronRight
                .foregroundStyle(.gray)
        }
    }

    var horizontalBookScroll: some View {
        
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            HStack(spacing: BookShelfUI.horizontalSpacing) {
                ForEach(
                    self.viewModel.bookArray,
                    id: \.bookId
                ) { _ in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: BookShelfUI.cardSize.width, height: BookShelfUI.cardSize.height)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    BookShelfCellView(viewModel: BookShelfCellViewModel(readingStatus: .reading, bookHistoryArray: [Book.DUMMY_BOOK]))
}


/*
 
     let context = PersistenceController.shared.context
 CoreDataManager.shared.createBook(
     bookId: "book1",
     bookName: "book11",
     imagePath: "imagePath",
     context: context
 )
 */
