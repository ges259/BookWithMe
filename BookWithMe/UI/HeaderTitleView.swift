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
    let showChevron: Bool
    let alignment: HeaderAlignment
    
    init(
        title: String,
        appFont: AppFontStyle,
        showChevron: Bool = true,
        alignment: HeaderAlignment = .leading
    ) {
        self.title = title
        self.appFont = appFont
        self.showChevron = showChevron
        self.alignment = alignment
    }

    var body: some View {
        HStack {
            Text(title)
                .appFont(appFont)
                .foregroundStyle(.primary)
            
            if alignment == .leading { Spacer() }

            if showChevron {
                Image.chevronRight
                    .foregroundStyle(.black)
            }
        }
        .padding(.vertical, 15)
    }
}






#Preview {
    HeaderTitleView(
        title: "HeaderTitleView",
        appFont: .bookShelfCell
    )
}
