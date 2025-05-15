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
    let size: BookCardSize

    var body: some View {
//        KFImage(URL(string: imageURL))
//            .placeholder { Color.contentsBackground2 } // 로딩 중 placeholder
//            .resizable()
//            .scaledToFill()
//            .bookSize(self.size)
//            .defaultCornerRadius()
//            .defaultShadow()
        Rectangle()
            .background(Color.baseButton)
            .bookSize(self.size)
            .defaultCornerRadius()
            .defaultShadow()
    }
}

#Preview {
    BookCardView(imageURL: "", size: .small)
}
