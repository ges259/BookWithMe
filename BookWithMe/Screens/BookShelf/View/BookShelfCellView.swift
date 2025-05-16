//
//  BookShelfCellView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI



// MARK: - Main Cell View
struct BookShelfCellView: View {
    
    enum Constants {
        static let cardSize = CGSize(width: 80, height: 120)
        
        static let horizontalSpacing: CGFloat = 12
        static let headerTopPadding: CGFloat = 25
    }
    
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
            // HStack
            LazyHStack(spacing: Constants.horizontalSpacing) {
                // 테이블뷰 만들기
                ForEach(viewModel.bookArray, id: \.id) { lightBook in
                    // 화면이동을 위한 NavigationLink
                    NavigationLink {
                        BookDataView(
                            viewModel: BookDataViewModel(book: lightBook)
                        )
                    } label: {
                        // 보여질 이미지
                        BookCardView(
                            imageURL: lightBook.imageURL,
                            size: .small
                        )
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    BookShelfCellView(viewModel: BookShelfCellViewModel(readingStatus: .reading))
}

