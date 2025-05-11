//
//  BookShelfCellView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

// MARK: - UI Constants
enum BookShelfConstants {
    static let cardSize = CGSize(width: 80, height: 120)
    
    static let horizontalSpacing: CGFloat = 12
    static let headerTopPadding: CGFloat = 25
}

// MARK: - Main Cell View
struct BookShelfCellView: View {
    var viewModel: BookShelfCellViewModel

    init(viewModel: BookShelfCellViewModel) {
        self.viewModel = viewModel
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            horizontalBookScroll
        }
        .padding(.top, 12)
        .padding(.bottom, 5)
        .padding(.horizontal)
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
        .defaultShadow()
        .padding(.horizontal)
    }
}

// MARK: - Subviews
private extension BookShelfCellView {
    var headerView: some View {
        return HeaderTitleView(
            title: self.viewModel.title,
            appFont: .bookShelfCell)
    }
    var horizontalBookScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            NavigationLink {
                // MARK: - Fix
//                BookDescriptionView(viewModel: BookDescriptionViewModel(book: Book.DUMMY_BOOK))
                BookDataView()
            } label: {
                LazyHStack(spacing: BookShelfConstants.horizontalSpacing) {
                    ForEach(viewModel.bookArray, id: \.id) { book in
                        BookCardView(imageURL: book.imageURL,
                                     size: .small)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    BookShelfCellView(viewModel: BookShelfCellViewModel(readingStatus: .reading))
}

