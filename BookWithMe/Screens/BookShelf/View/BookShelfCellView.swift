//
//  BookShelfCellView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

// MARK: - UI Constants
enum BookShelfUI {
    static let cardSize = CGSize(width: 80, height: 120)
    static let cornerRadius: CGFloat = 16
    static let horizontalSpacing: CGFloat = 12
    static let shadowRadius: CGFloat = 4
    static let shadowYOffset: CGFloat = 2
    static let headerTopPadding: CGFloat = 25
}

// MARK: - Main Cell View
struct BookShelfCellView: View {
    var viewModel: BookShelfCellViewModel

    init(viewModel: BookShelfCellViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            Button {
                print(self.viewModel.bookArray)
            } label: {
                Text("뭐냐")
            }

            horizontalBookScroll
        }
        .padding(.bottom, 5)
        .padding(.horizontal)
        .background(Color.contentsBackground1)
        .clipShape(RoundedRectangle(cornerRadius: BookShelfUI.cornerRadius))
        .shadow(
            color: .black.opacity(0.1),
            radius: BookShelfUI.shadowRadius,
            x: 0,
            y: BookShelfUI.shadowYOffset
        )
        .padding(.horizontal)
    }
}

// MARK: - Subviews
private extension BookShelfCellView {
    var header: some View {
        return HeaderTitleView(title: self.viewModel.title)
    }
    var horizontalBookScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: BookShelfUI.horizontalSpacing) {
                ForEach(viewModel.bookArray, id: \.bookId) { book in
                    BookCardView(imageURL: book.imageString)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    BookShelfCellView(viewModel: BookShelfCellViewModel(readingStatus: .reading))
}
