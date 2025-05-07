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
            self.header
            ScrollView {
                self.lazyVGrid
            }
        }
        .padding(.horizontal)
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
    }
}

private extension ReadingHistoryCellView {
    var header: some View {
        HeaderTitleView(title: self.viewModel.title, showChevron: false)
    }
    
    var lazyVGrid: some View {
        return LazyVGrid(
            columns: ReadingHistoryUI.columns,
            alignment: .leading,
            spacing: 20
        ) {
            ForEach(viewModel.bookArray, id: \.bookId) { book in
                BookCardView(imageURL: book.imageString, size: .small)
            }
        }
    }
}

#Preview {
    ReadingHistoryCellView(
        viewModel: BookShelfCellViewModel(readingStatus: .reading)
    )
}
