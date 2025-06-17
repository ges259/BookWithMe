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
    let imageURL: String?
    let size: BookCardSize

    var body: some View {
        if let imageURL {
            self.imageWithURL(imageURL)
        } else {
            self.baseImage
        }
    }
}

private extension BookCardView {
    @MainActor
    func imageWithURL(_ url: String) ->  some View {
        return  KFImage(URL(string: url))
            .placeholder { Color.contentsBackground2 } // 로딩 중 placeholder
            .resizable()
            .bookSize(self.size)
            .scaledToFill()
            .defaultCornerRadius()
            .defaultShadow()
    }
    
    var baseImage: some View {
        return Rectangle()
            .foregroundStyle(Color.clear)
            .bookSize(self.size)
            .defaultCornerRadius()
            .defaultShadow()
    }
}

#Preview {
    BookCardView(imageURL: "", size: .small)
}
