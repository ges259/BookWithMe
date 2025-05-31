//
//  HistoryStatusView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/10/25.
//

import SwiftUI
import BottomSheet

struct HistoryStatusView: View {
    @Binding var bottomSheetPosition: BottomSheetPosition
    @Binding var selectedStatus: ReadingStatus
    let items: [ReadingStatus] = ReadingStatus.historyStatus
    
    
    
    var body: some View {
        VStack(spacing: 10) {
            self.headerView
            self.lazyVGridView
            self.bottomButtonView
        }
        .padding()
    }
}

private extension HistoryStatusView {
    var headerView: some View {
        return HeaderTitleView(
            title: "독서 상태를 설정해 주세요",
            appFont: .historyHeaderViewFont,
            alignment: .center
        )
    }
    
    
    var lazyVGridView: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 0), 
                           count: 2),
            spacing: 0
        ) {
            ForEach(items.indices, id: \.self) { index in
                let status = items[index]
                let isSelected = selectedStatus == status

                GeometryReader { geometry in
                    let width = geometry.size.width

                    Text(status.title)
                        .frame(width: width, height: width) // 정사각형
                        .background(isSelected
                                    ? Color.contentsBackground2
                                    : Color.contentsBackground1)
                        .foregroundColor(.black)
                        .onTapGesture {
                            selectedStatus = status
                        }
                }
                .aspectRatio(1, contentMode: .fit) // 정사각형 유지
            }
        }
        .defaultCornerRadius()
    }
    
    var bottomButtonView: some View {
        return BottomButtonView(title: "저장하기") {
            bottomSheetPosition = .hidden
        }
    }
}


//#Preview {
//    HistoryStatusView()
//}
