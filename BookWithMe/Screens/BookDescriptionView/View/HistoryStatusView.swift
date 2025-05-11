//
//  HistoryStatusView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/10/25.
//

import SwiftUI

struct HistoryStatusView: View {
    @State private var selectedIndex: ReadingStatus? = nil
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
            showChevron: false,
            alignment: .center
        )
        .frame(maxWidth: .infinity)
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
    }
    
    var lazyVGridView: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 0), 
                           count: 2),
            spacing: 0
        ) {
            ForEach(items.indices, id: \.self) { index in
                let status = items[index]
                let isSelected = selectedIndex == status
                
                Text(status.title)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(isSelected
                                ? Color.contentsBackground2
                                : Color.contentsBackground1)
                    .foregroundColor(.black)
                    .onTapGesture {
                        selectedIndex = status
                    }
            }
        }
        .defaultCornerRadius(16)
    }
    
    
    var bottomButtonView: some View {
        return Button {
            print("bottomButton")
        } label: {
            Text("저장하기")
                .frame(maxWidth: .infinity, maxHeight: 50)
                .foregroundStyle(Color.black)
                .contentShape(Rectangle()) // 터치 영역 확장
        }
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
    }
}


#Preview {
    HistoryStatusView()
}
