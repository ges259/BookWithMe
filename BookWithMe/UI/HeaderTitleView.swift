//
//  HeaderTitleView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI

struct HeaderTitleView: View {
    let title: String
    let showChevron: Bool  // chevron 이미지 표시 여부
    
    init(
        title: String,
        showChevron: Bool = true
    ) {
        self.title = title
        self.showChevron = showChevron
    }
    
    var body: some View {
        HStack {
            Text(self.title)
                .font(.headline)
                .foregroundStyle(.primary)
            Spacer()
            // chevron 이미지의 true여부에 따라 설정
            if self.showChevron {
                Image.chevronRight
                    .foregroundStyle(.black)
            }
        }.padding(.top, BookShelfUI.headerTopPadding)
    }
}

#Preview {
    HeaderTitleView(title: "HeaderTitleView")
}
