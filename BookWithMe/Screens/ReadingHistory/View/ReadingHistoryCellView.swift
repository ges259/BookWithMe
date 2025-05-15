//
//  ReadingHistoryCellView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI

struct ReadingHistoryCellView: View {
    
    let viewModel: BookShelfCellViewModel
    
    
    var body: some View {
        VStack {
            self.headerView
            ScrollView {
                self.lazyVGridView
            }
        }
        .padding(.horizontal)
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
    }
}

private extension ReadingHistoryCellView {
    var headerView: some View {
        HeaderTitleView(
            title: self.viewModel.title,
            appFont: .readingHistorySectionTitle)
    }
    
    var lazyVGridView: some View {
        return LazyVGrid(
            columns: ReadingHistoryUI.columns,
            alignment: .leading,
            spacing: 20
        ) {
            
            // HStack
            LazyHStack(spacing: 12) {
                // 테이블뷰 만들기
                ForEach(viewModel.bookArray, id: \.id) { book in
                    // 화면이동을 위한 NavigationLink
                    NavigationLink {
                        BookDataView(viewModel: BookDataViewModel(book: book))
                    } label: {
                        // 보여질 이미지
                        BookCardView(imageURL: book.imageURL ?? "",
                                     size: .small)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    ReadingHistoryCellView(
        viewModel: BookShelfCellViewModel(readingStatus: .reading)
    )
}
