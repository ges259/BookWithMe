//
//  ReadingHistoryView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct ReadingHistoryView: View {
    let viewModel: ReadingHistoryViewModel
    
    // 현재 보고 있는 페이지 인덱스 (selectedTab -> currentPage로 변경)
    @State private var currentPage = 0

    init(viewModel: ReadingHistoryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        // 이전/다음 페이지가 살짝 보이는 페이징 뷰
        // 현재 페이지 인덱스를 PagingTabView와 연결
        PagingTabView(currentPage: $currentPage) {
            // viewModel의 sectionData를 순회하면서 각 아이템에 대한 ReadingHistoryCellView를 만들고 AnyView로 감싸서 뷰 배열로 전달
            viewModel.sectionData.map { cellVM in
                AnyView(ReadingHistoryCellView(viewModel: cellVM))
            }
        }
    }
}

#Preview {
    ReadingHistoryView(
        viewModel: ReadingHistoryViewModel(
            coreDataManager: CoreDataManager.shared)
    )
}
