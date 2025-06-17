//
//  BookShelfCellView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct BookShelfCellView: View {
    
    enum Constants {
        static let cardSize = CGSize(width: 80, height: 120)
        
        static let horizontalSpacing: CGFloat = 12
        static let headerTopPadding: CGFloat = 25
    }
    
    var viewModel: BookShelfCellViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            content
        }
        .padding(.top, 10)
        .padding(.bottom, 5)
        .padding(.horizontal)
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
        .defaultShadow()
        .padding(5)
    }
}

// MARK: - Subviews
private extension BookShelfCellView {
    var headerView: some View {
        return HeaderTitleView(
            title: self.viewModel.title,
            appFont: .bookShelfCell
        )
    }
    
    @ViewBuilder
    var content: some View {
        if self.viewModel.bookArray.isEmpty {
            baseCardView
        } else {
            horizontalBookScroll
        }
    }
    
    var baseCardView: some View {
        return BookCardView(
            imageURL: nil,
            size: viewModel.cardSize()
        )
    }
    
    var horizontalBookScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            // HStack
            LazyHStack(spacing: Constants.horizontalSpacing) {
                // 테이블뷰 만들기
                ForEach(viewModel.bookArray, id: \.id) { book in
                    // 화면이동을 위한 NavigationLink
                    NavigationLink {
                        BookDataView(
                            viewModel: BookDataViewModel(
                                bookCache: BookCache.shared, 
                                coreDataManager: CoreDataManager.shared,
                                book: book
                            )
                        )
                    } label: {
                        BookCardView(
                            imageURL: book.imageURL,
                            size: viewModel.cardSize()
                        )
                    }
                }
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    BookShelfCellView(viewModel: BookShelfCellViewModel(readingStatus: .reading))
}

