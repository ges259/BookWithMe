//
//  BookShelfView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct BookShelfView: View {
    
    let viewModel: BookShelfViewModel = BookShelfViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    self.lazyVStackView
                }
            }
        }.background(Color.baseBackground)
    }
}


private extension BookShelfView {
    var lazyVStackView: some View {
        return ForEach(
            self.viewModel.sections,
            id: \.readingStatus
        ) { cellVM in
            BookShelfCellView(viewModel: cellVM)
        }
    }
}

#Preview {
    BookShelfView()
}
