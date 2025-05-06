//
//  BookCardView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI
import Kingfisher

// MARK: - Book Card View
struct BookCardView: View {
    let imageURL: String

    var body: some View {
        KFImage(URL(string: imageURL))
            .placeholder { Color.contentsBackground2 } // 로딩 중 placeholder
            .resizable()
            .scaledToFill()
            .frame(width: BookShelfUI.cardSize.width,
                   height: BookShelfUI.cardSize.height)
            .cornerRadius(BookShelfUI.cornerRadius)
            .shadow(
                color: .black.opacity(0.1),
                radius: BookShelfUI.shadowRadius,
                x: 0,
                y: BookShelfUI.shadowYOffset
            )
            .clipped() // `cornerRadius`와 함께 사용될 때 필수
    }
}
#Preview {
    BookCardView(imageURL: "")
}
