//
//  ReadingHistoryCellView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI

struct ReadingHistoryCellView: View {
    enum Constants {
        static let columns = Array(repeating: GridItem(.flexible()), count: 3)
        static let itemSpacing: CGFloat = 20
        static let verticalPadding: CGFloat = 4
    }
    
    
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
         LazyVGrid(
             columns: Constants.columns,
             alignment: .leading,
             spacing: Constants.itemSpacing
         ) {
             ForEach(viewModel.bookArray) { book in
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
                         size: .small
                     )
                 }
             }
         }
         .padding(.vertical, Constants.verticalPadding)
     }
}

#Preview {
    ReadingHistoryCellView(
        viewModel: BookShelfCellViewModel(readingStatus: .reading)
    )
}
