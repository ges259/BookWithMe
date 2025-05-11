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
            appFont: .readingHistorySectionTitle,
            showChevron: false)
    }
    
    var lazyVGridView: some View {
        return LazyVGrid(
            columns: ReadingHistoryUI.columns,
            alignment: .leading,
            spacing: 20
        ) {
            ForEach(viewModel.bookArray, id: \.id) { book in
                BookCardView(imageURL: book.imageURL, size: .small)
            }
        }
    }
}

#Preview {
    ReadingHistoryCellView(
        viewModel: BookShelfCellViewModel(readingStatus: .reading)
    )
}
