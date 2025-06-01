//
//  BookShelfView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct BookShelfView: View {
    
    let viewModel: BookShelfViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                self.lazyVStackView
            }
        }
    }
}


private extension BookShelfView {
    var lazyVStackView: some View {
        return ForEach(
            self.viewModel.sectionData,
            id: \.readingStatus
        ) { cellVM in
            BookShelfCellView(viewModel: cellVM)
        }
    }
}

#Preview {
    BookShelfView(viewModel: BookShelfViewModel())
}
