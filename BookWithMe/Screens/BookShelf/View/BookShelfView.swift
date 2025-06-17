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
        VStack(spacing: 0) {
            // 1) 추천 카드
            if let rec = self.viewModel.recommendedSection {
                BookShelfCellView(viewModel: rec)
            }
            
            // 2) 2×2 상태 그리드
            LazyVGrid(columns: self.viewModel.gridColumns, spacing: 0) {
                ForEach(self.viewModel.otherSections, id: \.readingStatus) { cellVM in
                    BookShelfCellView(viewModel: cellVM)
                }
            }
        }
        .padding(.horizontal, 10)
    }
}
