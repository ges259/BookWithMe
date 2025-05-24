//
//  HeaderTitleView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI

struct HeaderTitleView: View {
    let title: String
    let appFont: AppFontStyle
    let rightImage: HeaderRightImageType
    let alignment: HeaderAlignment
    
    init(
        title: String,
        appFont: AppFontStyle,
        rightImage: HeaderRightImageType = .none,
        alignment: HeaderAlignment = .leading
    ) {
        self.title = title
        self.appFont = appFont
        self.rightImage = rightImage
        self.alignment = alignment
    }

    var body: some View {
        HStack {
            // 헤더 타이틀 설정ㅡ
            Text(title)
                .appFont(appFont)
                .foregroundStyle(.primary)
            
            // alignment 설정
            if alignment == .leading { Spacer() }
            
            // HeaderRightImageType 타입에 따라 이미지 설정
            if let rightImage = rightImage.image {
                rightImage
                    .foregroundStyle(.black)
                
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
    }
}






#Preview {
    HeaderTitleView(
        title: "HeaderTitleView",
        appFont: .bookShelfCell
    )
}
